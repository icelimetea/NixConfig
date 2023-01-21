{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  hardware = {
    opengl.extraPackages = [ pkgs.intel-media-driver ];

    cpu.intel.updateMicrocode = true;
  };

  boot.initrd.luks.devices.osroot.device = "/dev/disk/by-uuid/ad14ec83-8910-4fd1-9344-a8ab945f0983";
}
