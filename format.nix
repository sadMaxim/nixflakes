{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    { ... }:
    {
      treefmt.projectRootFile = ./flake.nix;
      treefmt.programs.nixpkgs-fmt.enable = true;
      treefmt.programs.mypy.enable = true;
    };
}
