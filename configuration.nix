let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;
  packages = import ./all-packages.nix { inherit (pkgs) newScope; };
  overlayModule = { ... }: {
    nixpkgs.overlays = [ (final: prev: packages) ];
  };
in
# sudo nixos-container destroy foo
  # sudo nixos-container create foo --config-file configuration.nix
{ ... }:
{
  imports = [
    ./configs/liberaforms/container.nix
    overlayModule
  ];
}

