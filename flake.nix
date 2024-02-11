{
  description = "useful programms";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";



  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [];
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      flake.herculesCI.ciSystems = [ "x86_64-linux" ];
      perSystem = {pkgs,...} : {
      packages.vpn-toggle = pkgs.writeShellApplication {
        name = "vpn-toggle";
        runtimeInputs = [];
        text = ''
          STATE_FILE="/tmp/wg0-active"

          if [[ ! -f "$STATE_FILE" ]]; then
              wg-quick up "wg0"
              touch "$STATE_FILE"
          else
              wg-quick down "wg0"
              rm "$STATE_FILE"
          fi
        '';
      };
      };
    };
nixConfig = {
    extra-substituters = [
      "https://cache.iog.io"
    ];
    extra-trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

}
