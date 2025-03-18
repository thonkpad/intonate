{
  description = "Intonate";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        ocamlPackages = pkgs.ocamlPackages;

        buildInputs = [
          pkgs.ffmpeg-full
          ocamlPackages.base
          ocamlPackages.dream
          ocamlPackages.lwt_ppx
        ];

        nativeBuildInputs = with pkgs; [
          ocamlPackages.ocaml
          # the dune build system
          ocamlPackages.dune_3

          # If you're on NixOS, you'll probably want this (See: https://nixos.wiki/wiki/OCaml#Findlib.2C_ocamlfind)
          ocamlPackages.findlib

          # Additionally, add any development packages you want
          # A fancy REPL...
          ocamlPackages.utop
          # Editor integration...
          ocamlPackages.merlin
          ocamlPackages.ocaml-lsp
          # Formatting...
          ocamlPackages.ocamlformat
          ocamlPackages.ocp-indent

          vscode-langservers-extracted
          nodePackages.prettier
        ];
      in {
        packages = {
          default = ocamlPackages.buildDunePackage {
            pname = "intonate";
            version = "0.0.0";
            duneVersion = "3";
            src = ./.;

            strictDeps = true;

            inherit nativeBuildInputs buildInputs;
          };
        };

        devShells.default =
          pkgs.mkShell { inherit nativeBuildInputs buildInputs; };
      });
}
