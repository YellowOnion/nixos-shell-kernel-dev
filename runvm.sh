#!/usr/bin/env bash
export BCACHEFS_VM_DIR=$(realpath ./vm)

nice -n 10                                                          \
    make -j12                                                       \
    --directory=bcachefs/                                           \
    O=../kernel/                                                    \
    KCFLAGS="-Wno-error=format-security -Wformat-security"          \
    && cd bcachefs                                                  \
    && ./scripts/clang-tools/gen_compile_commands.py -d ../kernel   \
    && cd ..                                                        \
    && [ ! -z $0 ]                                                  \
    && nice -n 10 sudo nixos-shell vm.nix
