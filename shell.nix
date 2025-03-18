{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_2;
  mlPkgs = with ocamlPackages; [ base core dream lwt_ppx ];

in mkShell {
  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    dune_3
    ocaml-lsp
    utop
    merlin
    ocp-indent
    ocamlformat
  ];

  buildInputs = with pkgs;
    [ ffmpeg-full vscode-langservers-extracted nodePackages.prettier ]
    ++ mlPkgs;
}
