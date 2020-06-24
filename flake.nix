{
  description = "nixos-container example flake";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  
  outputs = { self, nixpkgs }:
    with import nixpkgs { system = "x86_64-linux"; }; # makes `pkgs` available
    rec {

      packages = {
        webroot = pkgs.writeTextDir "index.html" ''
          <!doctype html>
          Hello, World!
       '';
      };

      # https://github.com/NixOS/nixpkgs/pull/68897
      # https://github.com/NixOS/nixos-homepage/blob/506001aa51806aac4f3680e61d9c9bee3466ef81/flake.nix#L97-L111
      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            system.configurationRevision = self.rev;
            boot.isContainer = true;
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [ 80 ];
            services.darkhttpd = {
              enable = true;
              rootDir = self.packages.webroot;
            };
          }];
      };
    };
}
