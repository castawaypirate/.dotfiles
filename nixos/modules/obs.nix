{ config, pkgs, lib, ... }:

let
  # OBS and DroidCam must link the same FFmpeg (libavcodec ABI); stock nixpkgs
  # builds both against the default ffmpeg, so no override is needed
  ffmpegOf = drv: lib.findFirst (p: (p.pname or "") == "ffmpeg") null drv.buildInputs;
  obsFfmpeg = ffmpegOf pkgs.obs-studio;
  droidFfmpeg = ffmpegOf pkgs.obs-studio-plugins.droidcam-obs;
in
{
  # Fail the rebuild instead of crashing OBS if nixpkgs ever splits them
  # (recovery steps: ~/System/obs_droidcam_rollback.md)
  assertions = [{
    assertion = obsFfmpeg.version == droidFfmpeg.version;
    message = "droidcam-obs uses ffmpeg ${droidFfmpeg.version} but OBS uses ${obsFfmpeg.version}";
  }];

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
      # Fallback if the assertion fails: (droidcam-obs.override { ffmpeg = obsFfmpeg; })
      obs-pipewire-audio-capture
      obs-backgroundremoval

      # wlrobs (for hyprland?)
    ];
  };

  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    droidcam
    v4l-utils
    android-tools
  ];
}
