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
  };

  # Open port 80 for HTTP and 6969 for blog backend
  networking.firewall.allowedTCPPorts = [ 80 6969 ];
}
