{
  description = "mypackages";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.treefmt-nix.url = "github:numtide/treefmt-nix";
  inputs.nixvim.url = "github:nix-community/nixvim";



  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./shell.nix
        # ./format.nix
        ./my-nvim
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      flake.herculesCI.ciSystems = [ "x86_64-linux" ];
    };

}
