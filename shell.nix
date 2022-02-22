{ pkgs ? import <nixpkgs> {} }:
let
  tools = pkgs.callPackage ./bcachefs-tools { doCheck = false ;};
in
pkgs.mkShell {
  #name = "linux-kernel-build";
  nativeBuildInputs = with pkgs; [
  ];
  buildInputs = with pkgs; [
    gist
    getopt
    flex
    bison
    gcc
    gnumake
    gdb
    bc
    linuxKernel.packages.linux_5_10.perf
    pkg-config
    binutils
    python3
    pahole
    qemu
    nixos-shell # see vm.nix
    elfutils
    ncurses
    openssl
    zlib
    clang-tools

    minicom # ktest
    socat
    vde2
  ];
  inputsFrom = [
    tools
  ];
}
