{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self,nixpkgs }: 
    let 
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {

    foo = "bar";
    packages.x86_64-linux.hello = pkgs.hello;
    devShell.x86_64-linux = pkgs.mkShell {buildInputs = [self.packages.x86_64-linux.hello pkgs.cowsay]; }; 

    #defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;
    };

  
}
