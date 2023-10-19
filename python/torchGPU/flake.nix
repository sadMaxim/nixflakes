{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    utils.url = "github:numtide/flake-utils"; nixgl.url = "github:guibou/nixGL";
  };

  outputs = { self, nixpkgs, utils, nixgl }:
    let out = system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.cudaSupport = true;
          config.allowUnfree = true;
          overlays = [nixgl.overlay];
        };
        inherit (pkgs.cudaPackages) cudatoolkit;
        inherit (pkgs.linuxPackages) nvidia_x11;
        python = pkgs.python310;
        torch = pkgs.python310Packages.torch;
        torchCuda = pkgs.python310Packages.torchWithCuda;
        shellHook = ''
            export CUDA_PATH=${cudatoolkit.lib}
            export LD_LIBRARY_PATH=${cudatoolkit.lib}/lib:${nvidia_x11}/lib
            export EXTRA_LDFLAGS="-l/lib -l${nvidia_x11}/lib"
            export EXTRA_CCFLAGS="-i/usr/include"
            python -c "import torch; print(torch.cuda.is_available())"

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
          #buildInputs = [nvidia_x11 cudatoolkit];
          /* buildInputs = [torchCuda magma]; */
          buildInputs = [pkgs.magma];
          inherit shellHook;  
        };
      }; in with utils.lib; eachSystem defaultSystems out;
}
