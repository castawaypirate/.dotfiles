{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    
    # Run as your user
    user = "castaway";
    
    # Set the data and config paths explicitly
    dataDir = "/home/castaway/Notes/org"; 
    configDir = "/home/castaway/.config/syncthing";

    # Automatically open the required firewall ports (22000 TCP/UDP, 21027 UDP)
    openDefaultPorts = true;

    # Enforce Nix as the single source of truth
    overrideDevices = true;     
    overrideFolders = true;     

    settings = {
      devices = {
        "android" = { id = "6HWFPUW-M35Q4XY-7CYDAXG-RJA3FSH-ZNMSS6C-L5KTG5I-U2PINEF-XYH7GQO"; };
        "desktop" = { id = "2BLG2HE-ZQ3PELF-HXRJ3OY-O54G7BA-UHH7FVR-FQUXW3V-WDAHKAF-VEIPZQW"; };
      };
      
      folders = {
        "Org Notes" = {
          path = "/home/castaway/Notes/org";
          devices = [ "android" "desktop" ]; 
          id = "jxuxm-mnken"; 
        };
      };
    };
  };
}
