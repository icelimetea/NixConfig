{ config, pkgs, nixpkgs, lib, ... }: {
  boot = {
    cleanTmpDir = true;

    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = lib.mkForce false;

      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  fileSystems."/boot" = {
    label = "efi-part";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/root-group/root-vol";

    fsType = "btrfs";
    options = [
      "compress-force=zstd:15"
      "noatime"
    ];
  };

  swapDevices = [
    { device = "/dev/root-group/swap-vol"; }
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

  i18n.defaultLocale = "en_GB.UTF-8";
  
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  nix.settings.auto-optimise-store = true;

  services = {
    fwupd.enable = true;
    thermald.enable = true;

    kresd = {
      enable = true;

      extraConfig = "policy.add(policy.all(policy.TLS_FORWARD{{ '1.0.0.1', hostname = 'cloudflare-dns.com' }}))";
    };
  };

  security = {
    rtkit.enable = true;
    sudo.enable = true;
  };
}
