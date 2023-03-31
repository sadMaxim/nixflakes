{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
    nix-gaming.url = github:fufexan/nix-gaming;
  };

  outputs = { self, nixpkgs, utils, nixgl, nix-gaming }:
    let out = system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.cudaSupport = true;
          config.allowUnfree = true;
          /* overlays = [nixgl.overlay]; */
        };
        inherit (pkgs.cudaPackages) cudatoolkit;
        inherit (pkgs.linuxPackages) nvidia_x11;
        python = pkgs.python310;
        torch = pkgs.python310Packages.torch;
	wine = nix-gaming.packages.${pkgs.hostPlatform.system}.wine-ge;
        torchCuda = pkgs.python310Packages.torchWithCuda;
        shellHook = ''
            export CUDA_PATH=${cudatoolkit.lib}
            export LD_LIBRARY_PATH=${cudatoolkit.lib}/lib:${nvidia_x11}/lib
            export EXTRA_LDFLAGS="-l/lib -l${nvidia_x11}/lib"
            export EXTRA_CCFLAGS="-i/usr/include"
            # python -c "import torch; print(torch.cuda.is_available())"

          '';
        shellHook1 = ''
            export CUDA_HOME=/opt/cuda/
            export FORCE_CUDA="1"
            python -c "import torch; print(torch.cuda.is_available())"
            python -c "from torch.utils.cpp_extension import CUDA_HOME; print(CUDA_HOME)"
            exit
          '';
      in
      {
        devShell = pkgs.mkShell {
          # buildInputs = [nvidia_x11 cudatoolkit torchCuda];
          # buildInputs = [nvidia_x11 cudatoolkit  pkgs.winePackages.unstableFull];
          buildInputs = [nvidia_x11 cudatoolkit  wine];
          inherit shellHook;  
        };
      packages.default = pkgs.hello; 
      packages.chrome = pkgs.google-chrome;
      packages.wine = pkgs.wineWowPackages.waylandFull;
      packages.codium = pkgs.vscodium;
      /* packages.nixgl = nixgl.packages.x86_64-linux.default; */
      }; in with utils.lib; eachSystem defaultSystems out;
}
