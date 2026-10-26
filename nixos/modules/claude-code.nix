{ config, pkgs, ... }:

let
  # Moving ref: "latest" only advances after upstream CI passes; rebuild to update
  claude-code = builtins.getFlake "github:sadjow/claude-code-nix?ref=latest";
in
{
  # getFlake needs flakes enabled; first rebuild must pass this via --option
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.overlays = [ claude-code.overlays.default ];
  environment.systemPackages = [ pkgs.claude-code ];
}
