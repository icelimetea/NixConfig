
{ config, pkgs, nixpkgs, ... }: {
  boot = {
    initrd.luks.devices.osroot = { device = "/dev/disk/by-uuid/6a952187-6b91-4496-92d1-aad3b941e9b7"; };

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
    label = "os-efi";
    fsType = "vfat";
  };

  fileSystems."/" = {
    label = "os-root";
    fsType = "ext4";
  };

  swapDevices = [
    {
      label = "os-swap";
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
    keyMap = "uk";
  };

  services.fwupd.enable = true;

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
