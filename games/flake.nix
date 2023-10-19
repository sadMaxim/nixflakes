{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:guibou/nixGL";
    nix-gaming.url = github:fufexan/nix-gaming;
  };

  outputs = { self, nixpkgs, utils, nixgl, nix-gaming }:
    let out = system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [nixgl.overlay];
        };
        inherit (pkgs.linuxPackages) nvidia_x11 nvidia_x11_vulkan_beta;

        # bench = pkgs.glmark2.override{libGL="${nvidia_x11}/lib";};
        bench = pkgs.unigine-heaven;
        bench2 = pkgs.glmark2;

        shellHook = ''
            export LD_LIBRARY_PATH=${nvidia_x11}/lib:$LD_LIBRARY_PATH
            export LANG=en_US.UTF-8
            export LC_ALL=en_US.UTF-8
          '';
            # export LD_LIBRARY_PATH=${nvidia_x11}/lib:$LD_LIBRARY_PATH
            # export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH
            # export LD_DEBUG=all
            # export CUDA_PATH=${cudatoolkit.lib}
            # export LD_LIBRARY_PATH=${cudatoolkit.lib}/lib:${nvidia_x11}/lib
            # export EXTRA_LDFLAGS="-l/lib -l${nvidia_x11}/lib"
            # export EXTRA_CCFLAGS="-i/usr/include"
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
                         # pkgs.nixgl.auto.nixGLDefault
                         # pkgs.nixgl.auto.nixVulkanNvidia
                         # pkgs.nixgl.auto.nixGLNvidia
                         # pkgs.gravit
                         # pkgs.bottles-unwrapped
                         # bench bench2

                         ];
          # buildInputs = [bench pkgs.strace pkgs.wineWowPackages.full];
          inherit shellHook;  
        };
      packages.default = pkgs.hello; 
      packages.nixGLDefault = pkgs.nixgl.auto.nixGLDefault;
      packages.wine = pkgs.wineWowPackages.full;
      packages.chrome = pkgs.google-chrome;
      packages.codium = pkgs.vscodium;
      /* packages.nixgl = nixgl.packages.x86_64-linux.default; */
      }; in with utils.lib; eachSystem defaultSystems out;
}
