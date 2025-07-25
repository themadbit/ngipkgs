{
  sources,
  lib,
  ...
}:
let
  inherit (lib)
    mkForce
    ;
in
{
  name = "atomic-server";

  nodes = {
    server =
      {
        config,
        lib,
        ...
      }:
      {
        imports = [
          sources.modules.ngipkgs
          sources.modules.services.atomic-server
          sources.examples.AtomicData."Enable Atomic Server"
        ];
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      server.wait_for_open_port(9883) # curl fails otherwise

      with subtest("atomic"):
          server.wait_for_unit("atomic-server.service")
          server.succeed("curl --fail --connect-timeout 10 http://localhost:9883/setup")
    '';
}
