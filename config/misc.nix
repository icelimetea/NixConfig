
{ config, pkgs, nixpkgs, ... }: {
  boot = {
    initrd.luks.devices.osroot = { device = "/dev/disk/by-uuid/be95d7bc-4ee4-491b-b4b9-0eb8c32fdc9c"; };

    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = false;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };

      grub = {
        enable = true;

        version = 2;
        efiSupport = true;

        enableCryptodisk = true;
        device = "nodev";
      };
    };
  };

  fileSystems."/efi" = {
    label = "efi-part";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/root-group/root-vol";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/dev/root-group/swap-vol";
    }
  ];

  powerManagement.cpuFreqGovernor = "performance";

  networking = {
    useDHCP = false;
    
    networkmanager = {
      enable = true;

      enableStrongSwan = true;

      plugins = [ pkgs.networkmanager-openvpn ];
    };

    dhcpcd.enable = false;
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.fwupd.enable = true;
  services.thermald.enable = true;

  security = {
    rtkit.enable = true;
    sudo.enable = true;
  };

  users.users = {
    lemontea = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
