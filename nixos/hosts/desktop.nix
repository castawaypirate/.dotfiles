{ config, pkgs, ... }:

{
  imports =
    [ 
      # System-generated hardware config stays in /etc/nixos
      /etc/nixos/hardware-configuration.nix
      
      # Shared user/system config
      ../common.nix

      # Standalone Modules
      ../modules/apache2.nix
      ../modules/syncthing.nix
      ../modules/nvim.nix
      ../modules/obs.nix
      ../modules/claude-code.nix
      ../modules/antigravity.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "machine"; 

  # MariaDB (MySQL-compatible)
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    # Local development only: accept connections from this machine
    settings.mysqld.bind-address = "127.0.0.1";
    # Run scheduled events (blogdot's delete_users), same as production
    settings.mysqld.event_scheduler = "ON";
  };
}
