{ inputs, self, ... }:
{
  perSystem =
    { pkgs, self', ... }:
    {

      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # packages for development in python
          # nixd
        ];
        shellHook = ''
        '';
      };

    };
}
