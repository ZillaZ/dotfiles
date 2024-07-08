{ pkgs ? import <nixpkgs> {} }:
let
  src = builtins.fetchGit {
    url = "https://github.com/casualsnek/waydroid_script";
    ref = "main";
    rev = "1a2d3ad643206ad5f040e0155bb7ab86c0430365";
  };
  resetprop = pkgs.stdenv.mkDerivation {
    name = "resetprop";
    inherit src;
    installPhase = ''
      mkdir -p $out/share
      cp -r bin/* $out/share/
    '';
  };
in
pkgs.mkShell rec {
  buildInputs = with pkgs; [
    clang
    llvmPackages.bintools
    rustup
    gcc
    libgccjit
    libgcc
    stdenv
  ];
  VAR ="\"${resetprop}/share\",";
}
