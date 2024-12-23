{ inputs, self, ... }:
{
  perSystem = { system, pkgs, ... }:
    {
    _module.args.pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      # inputs.foo.overlays.default
      # (final: prev: {
      #   
      # })
    ];
    config.allowUnfree = true;
    };
      packages.nvim1  = let 
          nixvimLib = inputs.nixvim.lib.${system};
          nixvim' = inputs.nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit pkgs;
            module = import ./config.nix (pkgs); 
          };
      in 
       nixvim'.makeNixvimWithModule nixvimModule;
    };
}
