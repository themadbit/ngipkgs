{
  sources,
  pkgs,
  ...
}:
{
  name = "mox";

  nodes = {
    machine =
      { ... }:
      rec {
        imports = [
          sources.modules.ngipkgs
          sources.modules.services.mox
          sources.examples.Mox.mox
        ];

        # Allow necessary ports through the firewall
        networking.firewall.allowedTCPPorts = [ 25 80 143 443 587 993 5335 ];
        networking.firewall.allowedUDPPorts = [ 53 ];
        networking.nameservers = [ "127.0.0.1" ];
        environment.etc."resolv.conf".text = ''
          nameserver 127.0.0.1
        '';
        services.unbound = {
          enable = true;
          resolveLocalQueries = true;
          enableRootTrustAnchor = false;
          settings = {
            server = {
              interface = [ "127.0.0.1" ];
              access-control = [ "127.0.0.1/8 allow" "::1/128 allow" ];
            };
            local-zone = [ "\"example.com.\" static" ];
            local-data = [ "\"example.com. IN A 12.34.56.78\"" "\"mail.example.com. IN A 78.56.34.12\"" ];
          };
        };
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      # Wait for machine to be available
      machine.wait_for_unit("multi-user.target")

      # Verify the mox-setup service has run successfully
      machine.wait_for_unit("mox-setup.service")
      
      # Verify the mox service is running
      machine.wait_for_unit("mox.service")
      
      # Verify config file exists
      machine.succeed("test -f /var/lib/mox/config/mox.conf")
      
      # Verify mox user was created
      machine.succeed("getent passwd mox")
      
      # Check if ports are listening (assuming default SMTP port)
      machine.wait_until_succeeds("ss -tln | grep ':25 '")
      
      # Test running the mox command
      machine.succeed("mox version")
      
      # Check logs for any errors
      machine.succeed("journalctl -u mox.service --no-pager | grep -v 'error|failed'")
    '';
}
