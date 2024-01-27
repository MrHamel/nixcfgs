{ config, pkgs, inputs, ... }:

{
  imports = with inputs.self.nixosModules;
    [
      ./hardware-configuration.nix
      groups-workstation
      ../../modules/roles/ntp/lax.nix
    ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

  boot.loader.grub = { 
    device = "nodev";
    enable = true;
    efiInstallAsRemovable = true;
    efiSupport = true;
    mirroredBoots = [
      { devices = [ "/dev/disk/by-id/0x5000c500a58567d2" ]; path = "/boot"; }
      { devices = [ "/dev/disk/by-id/0x5000c500a5869824" ]; path = "/boot2"; }
    ];
    zfsSupport = true;
  };

  fileSystems = { 
    "/" = { device = "zpool/root"; fsType = "zfs"; };
    "/nix" = { device = "zpool/nix"; fsType = "zfs"; };
    "/var" = { device = "zpool/var"; fsType = "zfs"; };
    "/home" = { device = "zpool/home"; fsType = "zfs"; };
    "/boot" = { device = "/dev/disk/by-uuid/11D3-B2A1"; fsType = "vfat"; };
    "/boot2" = { device = "/dev/disk/by-uuid/1184-A7A7"; fsType = "vfat"; };
  };

  swapDevices = [ ];

  networking = {
    hostName = "RKHTech-NixOS";
    hostId = "fae7c11b";

    interfaces.enp4s0.useDHCP =  true;

    networkmanager.enable = true;

    wireless.enable = false;
  };

  programs.zsh = { 
    shellAliases = {
      "update" = lib.mkForce "doas nixos-rebuild switch --upgrade-all --impure --flake /etc/nixos#hp";
    };
  };
}
