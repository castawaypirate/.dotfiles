{ config, pkgs, ... }:

let
  # 1. Create a custom version of OBS Studio that runs on FFmpeg 6
  obs-with-ffmpeg6 = pkgs.obs-studio.override { ffmpeg = pkgs.ffmpeg_6; };
in
{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    
    # 2. Tell NixOS to use our custom OBS instead of the default one
    package = obs-with-ffmpeg6;

    plugins = with pkgs.obs-studio-plugins; [
      # 3. Force DroidCam to use our custom OBS base AND FFmpeg 6
      (droidcam-obs.override { 
        obs-studio = obs-with-ffmpeg6;
        ffmpeg_7 = pkgs.ffmpeg_6; 
      })
      
      # 4. Safely link your other plugins to the same custom OBS base 
      # (Prevents instant crashes from mismatched OBS versions)
      (obs-pipewire-audio-capture.override { obs-studio = obs-with-ffmpeg6; })
      (obs-backgroundremoval.override { obs-studio = obs-with-ffmpeg6; })

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

