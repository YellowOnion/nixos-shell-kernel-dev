{ config, lib, pkgs, ... }:
let kernel = ./kernel/arch/x86/boot/bzImage;
    drives = [
      "file=/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS0NA78631F,format=raw,if=virtio"
      "file=/dev/disk/by-id/ata-WDC_WD2002FAEX-007BA0_WD-WMAY01259996,format=raw,if=virtio"
      "file=/dev/disk/by-id/ata-WDC_WD30EFRX-68EUZN0_WD-WCC4N0998010,format=raw,if=virtio"
      "file=/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-WCC7K6SAF6KD,format=raw,if=virtio"
      "file=/dev/disk/by-id/ata-WDC_WD40EFRX-68N32N0_WD-WCC7K7RT8J22,format=raw,if=virtio"
      "file=\"$BCACHEFS_VM_DIR\"/cache.img,format=raw,if=virtio,cache=unsafe,aio=io_uring"
      "file=\"$BCACHEFS_VM_DIR\"/backing.img,format=raw,if=virtio,cache=unsafe,aio=io_uring,iops=500,bps=$((1024**2*100))"
    ];
    drivesOps = lib.foldr (a: b:  ["-drive ${a},aio=native,cache.direct=on"] ++ b) [] drives;
    bcachefs-tools = (pkgs.callPackage ./bcachefs-tools {doCheck = false; dontStrip = true;});
in
{
  environment.systemPackages = with pkgs; [
    linuxKernel.packages.linux_5_15.perf
    screen
    htop
    sysstat
    killall
    fio
    bcachefs-tools
  ];
  services.getty.autologinUser = "root";
  virtualisation = {
    memorySize = 1024 * 8;
    #graphics = true;
    cores = 6;
    qemu.options = [
      "-kernel" "${kernel}"
    ] ++ drivesOps;
  };
}
