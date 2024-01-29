{ config, lib, pkgs, inputs, ... }:

{
  imports = with inputs.self.nixosModules;
    [
      ./hardware-configuration.nix
      groups-workstation
      ../../modules/roles/ntp/lax.nix
    ];

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

  boot.loader.grub.enable = false;
  boot.loader.grub.device = "nodev";

  environment.noXlibs = false;

  swapDevices = [ ];

  networking = {
    hostName = "RKHTech-iPXE-NixOS";
    hostId = "19390138";

    useDHCP = lib.mkForce true;
    wireless.enable = false;
  };

  programs.zsh = { 
    shellAliases = {
      "update" = lib.mkForce "doas nixos-rebuild switch --upgrade-all --impure --flake /etc/nixos#proxmox_lxc";
    };
  };

  #services.chrony.enable = true;
  #services.resolved.enable = false;

  #systemd.network.enable = true;

  #systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  systemd.services.zfs-mount.enable = false;
}
