{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Athens";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "el_GR.UTF-8";
    LC_IDENTIFICATION = "el_GR.UTF-8";
    LC_MEASUREMENT = "el_GR.UTF-8";
    LC_MONETARY = "el_GR.UTF-8";
    LC_NAME = "el_GR.UTF-8";
    LC_NUMERIC = "el_GR.UTF-8";
    LC_PAPER = "el_GR.UTF-8";
    LC_TELEPHONE = "el_GR.UTF-8";
    LC_TIME = "el_GR.UTF-8";
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable the X11 windowing system & KDE Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define user account
  users.users.castaway = {
    isNormalUser = true;
    description = "castaway";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      pkgs.transmission_4-qt
      docker
      dotnet-sdk
      kdePackages.kate
      phpPackages.composer
      ghostty
      vim-full
      unstable.pkgs.godot
      ripgrep
      # discord
      git
      google-chrome
      brave
      emacs-pgtk
      fd
      xsel
      xclip
      wl-clipboard
      scrot
      graphviz
      multimarkdown
      vlc
      yt-dlp
      ffmpeg
      tree
      gh
      rsync
      openssh
      kdePackages.ksshaskpass
    ];
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    vulkan-loader
    libGL
    libx11
    libxcursor
    libxinerama
    libxrandr
    libxi
    libxext
    alsa-lib
    libxkbcommon
    wayland
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    php
    nodejs
    vesktop
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    # symbola
  ];

  environment.shellAliases = {
    mysql = "mariadb";
  };

  # Enable Docker and ARM64 emulation for Raspberry Pi cross-compilation
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    preferStaticEmulators = true;
  };

  system.stateVersion = "25.11"; 
}
