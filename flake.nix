{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, nixpkgs, treefmt-nix, ... }@inputs:
    let
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      nixosConfigurations.nix = nixpkgs.lib.nixosSystem {
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
        ];
      };
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system}.formatter = treefmtEval.config.build.check self;
    };
}
