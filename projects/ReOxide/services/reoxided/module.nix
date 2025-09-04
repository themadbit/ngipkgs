{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

  cfg = config.services.reoxided;
  toToml = pkgs.formats.toml { };
  configFile = toToml.generate "reoxide.toml" cfg.ghidraInstall;

in
{
  options.programs.reoxided = {
    enable = mkEnableOption "enable reoxided";
    package = mkPackageOption pkgs "reoxide" { };

    ghidraInstall = mkOption {
      type = types.submodule {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable reoxide on Ghidra Installation";
        };
        root-dir = mkOption {
          type = types.str;
          default = "";
          description = "Ghidra root install directory";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cfg.package
    ];
    environment.etc."reoxide.toml".source = configFile;
  };
}
