{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/bbb32fa63aed0a09b32e923471aef8eed93a0096.tar.gz") {}
}:
let

in
pkgs.mkShell {
  #name = "linux-kernel-build";
  nativeBuildInputs = with pkgs; [
  ]; # ++ tools.nativeBuildInputs;
  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${pkgs.llvmPackages.libclang.lib}/lib/clang/${pkgs.lib.getVersion pkgs.clang}/include";
  buildInputs = with pkgs; [
    shellcheck
    shfmt
    gist
    getopt
    flex
    bison
    gcc
    gnumake
    gdb
    bc
    pkgs.linuxPackages_latest.perf
    fio
    #trace-cmd
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
    brotli
    socat
    vde2

    cargo
    llvmPackages.libclang
    rustPlatform.bindgenHook
    rust-analyzer
    libllvm
    openssl
    python3
  ];# ++ tools.buildInputs;
  inputsFrom = [
    pkgs.bcachefs-tools
  ];
}
