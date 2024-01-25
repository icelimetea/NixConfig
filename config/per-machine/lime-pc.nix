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

    nvidia = {
      modesetting.enable = true;

      prime = {
        offload = {
	  enable = true;
	  enableOffloadCmd = true;
        };

        intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  boot.initrd.luks.devices.vol1.device = "/dev/disk/by-uuid/fdac2ff7-7355-4c02-aefc-119d81e04aba";
  boot.initrd.luks.devices.vol2.device = "/dev/disk/by-uuid/5f4d07d1-18ac-4b32-b049-602a8813a288";
}
