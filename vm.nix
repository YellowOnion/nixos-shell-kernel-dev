{ config, lib, pkgs, ... }:
let kernel = ./kernel/arch/x86/boot/bzImage;
    drives = [
      "file=/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS0NA78631F,format=raw,cache=directsync"
      "file=/dev/disk/by-id/ata-WDC_WD2002FAEX-007BA0_WD-WMAY01259996,format=raw,cache=directsync"
      "file=/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N0998010,format=raw,cache=directsync"
      "file=/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-WCC7K6SAF6KD,format=raw,cache=directsync"
      "file=/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-WCC7K7RT8J22,format=raw,cache=directsync"
     # "file=\"$BCACHEFS_VM_DIR\"/cache.img,format=raw"
     # "file=\"$BCACHEFS_VM_DIR\"/backing.img,format=raw,iops=500,bps=$((1024**2*100))"
    ];
    drivesOps = (lib.foldr (a: {n, l}:
      { n = n+1;
        l = let n' = toString n; in ["-drive ${a},aio=native,if=none,id=disk${n'} -device virtio-blk-pci,drive=disk${n'}"] ++ l;
      }) {n =0;l = [];} drives).l;

    #bcachefs-tools = (pkgs.callPackage ./bcachefs-tools/binary.nix {doCheck = false;});
in
{
  boot.kernelParams = [ "quiet"
                        "noexec=off"
                        "oops=panic"
                      ];
  boot.kernelPackages = pkgs.linuxPackages_testing;

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.perf
    tmux
    htop
    sysstat
    killall
    fio
    bcachefs-tools
    #trace-cmd
    git
    git-crypt
    vim
  ];
  services.getty.autologinUser = "root";
  virtualisation = {
    memorySize = 1024 * 16;
    #graphics = true;
    # cores = 6;
    qemu.options = drivesOps ++ [
      "-smp" "4,sockets=1,cores=2,threads=2"
      "-echr 2" # tmux/screen support
      "-s"      # gdb server
      "-kernel ${kernel}"
      "-rtc" "clock=vm"
      "-cpu" "EPYC-Milan,topoext"
      "-machine" "q35"
      "-accel" "kvm"
    ] ;
  };
  system.stateVersion = "21.11";
}
