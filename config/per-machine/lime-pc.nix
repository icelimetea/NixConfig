{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  hardware = {
    opengl.extraPackages = [ pkgs.intel-media-driver ];

    cpu.intel.updateMicrocode = true;
  };

  boot.initrd.luks.devices.vol1.device = "/dev/disk/by-uuid/f7dc00c4-8dc8-43d7-bf92-9ea60aec5f84";
  boot.initrd.luks.devices.vol2.device = "/dev/disk/by-uuid/50048bb3-3c3b-442a-9aee-9c9ff3755e76";
}
