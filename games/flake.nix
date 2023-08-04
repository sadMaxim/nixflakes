{
  description = "antares-dev-shell";
  inputs.nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
  inputs.flake-utils.url = github:numtide/flake-utils;
  inputs.nixgl.url = github:guibou/nixGL/;

  outputs = { self, nixpkgs, flake-utils, nixgl, ... }:
    flake-utils.lib.eachDefaultSystem
      (system: let
          overlays = [ nixgl.overlay ]; pkgs = import nixpkgs { inherit system overlays; config.allowBroken = true; config.allowUnfree = true; };
          inherit (pkgs.cudaPackages) cudatoolkit;
          inherit (pkgs.linuxPackages) nvidia_x11;
          bottles = pkgs.bottles-unwrapped; 
          bottlesGL = pkgs.writeScriptBin "bottlesGL" '' 
              # export CUDA_PATH=${cudatoolkit.lib}
              export LD_LIBRARY_PATH=${cudatoolkit.lib}/lib:${nvidia_x11}/lib
              export EXTRA_LDFLAGS="-l/lib -l${nvidia_x11}/lib"
              export EXTRA_CCFLAGS="-i/usr/include"
              ${bottles}/bin/bottles
              '';

        devShell = with pkgs; mkShell{
            buildInputs = [
            bottles
            # nixgl.packages.${system}.nixGLNvidia
            ];
            shellHook = ''
              export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
              export LANG=en_US.UTF-8
              export LC_ALL=en_US.UTF-8
              export LC_CTYPE="en_US.UTF-8"
              export CUDA_PATH=${cudatoolkit.lib}
              export LD_LIBRARY_PATH=${cudatoolkit.lib}/lib:${nvidia_x11}/lib
              export EXTRA_LDFLAGS="-l/lib -l${nvidia_x11}/lib"
              export EXTRA_CCFLAGS="-i/usr/include"
              export XLA_FLAGS=--xla_gpu_cuda_data_dir=${cudatoolkit}/
            '';
            };
        in
        {
          packages = { inherit devShell bottles bottlesGL; };
          devShells.default = devShell; 

        }
      );
}
