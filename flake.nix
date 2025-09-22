{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          compiler = "ghc984";
          pvm = pkgs.haskell.packages.${compiler}.callPackage ./pvm { };
        in
        {
          packages = rec {
            inherit pvm;
            default = pvm;
          };
          devShells.default = pkgs.mkShell {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.zlib ];
            buildInputs = with pkgs.haskell.packages.${compiler}; [
              ghc
              cabal-install
              ghcid
              fourmolu
              cabal-fmt
              implicit-hie
              cabal2nix
              pkgs.ghciwatch
              pkgs.haskell-language-server
              pkgs.zlib
              pkgs.colordiff
            ];
          };
        })

    //
    {
      overlays.default = final: prev: {
        pvm =
          final.haskell.packages.ghc984.callPackage ./default.nix { };
      };
    };
}
