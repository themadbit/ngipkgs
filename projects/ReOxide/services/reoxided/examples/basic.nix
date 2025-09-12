{ lib, ... }:
{
  services.reoxided = {
    enable = true;
    ghidraInstall = [
      {
        enabled = lib.mkForce true;
      }
    ];
  };
}
