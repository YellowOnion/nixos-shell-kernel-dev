#!/usr/bin/env bash
export BCACHEFS_VM_DIR=$(realpath ./vm)
make -j12 --directory=bcachefs/ O=../kernel/ && sudo -E nixos-shell vm.nix
