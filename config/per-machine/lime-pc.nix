{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" "nouveau" ];
  boot.extraModulePackages = [ ];

  hardware = {
    graphics.extraPackages = [ pkgs.intel-media-driver ];

    cpu.intel.updateMicrocode = true;
  };

  boot.initrd.luks.devices.vol1.device = "/dev/disk/by-uuid/cd3d2b00-5828-4f3a-8c43-229bc5b52c45";
  boot.initrd.luks.devices.vol2.device = "/dev/disk/by-uuid/9918ad92-2996-47b9-b18e-849b4b71142b";
}
