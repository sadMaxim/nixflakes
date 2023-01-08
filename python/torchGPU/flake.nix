{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    let out = system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.cudaSupport = true;
          config.allowUnfree = true;
        };
        inherit (pkgs.cudaPackages) cudatoolkit;
        inherit (pkgs.linuxPackages) nvidia_x11;
        python = pkgs.python39;
        pythonEnv = pkgs.poetry2nix.mkPoetryEnv {
          inherit python;
          projectDir = ./.;
          preferWheels = true;
        };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [pythonEnv nvidia_x11 cudatoolkit];
          shellHook = ''
            export CUDA_PATH=${cudatoolkit.lib}
            export LD_LIBRARY_PATH=${cudatoolkit.lib}/lib:${nvidia_x11}/lib
            export EXTRA_LDFLAGS="-l/lib -l${nvidia_x11}/lib"
            export EXTRA_CCFLAGS="-i/usr/include"
          '';
        };
      }; in with utils.lib; eachSystem defaultSystems out;
}
