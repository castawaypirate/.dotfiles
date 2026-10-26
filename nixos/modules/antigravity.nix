{ config, pkgs, ... }:

let
  # Tracks main (upstream has no "latest" tag); rebuild to update
  antigravity = builtins.getFlake "github:jacopone/antigravity-nix";
in
{
  nixpkgs.overlays = [ antigravity.overlays.default ];

  environment.systemPackages = [
    # Isolated browser profile: the agent can't use logged-in Chrome sessions
    (pkgs.google-antigravity.override { useUserProfile = false; })
    pkgs.google-antigravity-cli
  ];
}
