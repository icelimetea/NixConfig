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

      dns = "none";

      enableStrongSwan = true;

      plugins = [ pkgs.networkmanager-openvpn ];
    };

    resolvconf = {
      enable = true;

      useLocalResolver = true;
    };

    dhcpcd.enable = false;
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    fwupd.enable = true;

    kresd = {
      enable = true;

      extraConfig = "policy.add(policy.all(policy.TLS_FORWARD{{ '1.0.0.1', hostname = 'cloudflare-dns.com' }}))";
    };
  };

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
