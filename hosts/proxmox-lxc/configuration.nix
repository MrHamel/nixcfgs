{ config, lib, pkgs, inputs, ... }:

{
  imports = with inputs.self.nixosModules;
    [
      ./hardware-configuration.nix
      groups-workstation
      ../../modules/roles/ntp/lax.nix
    ];

  boot.isContainer = true;
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

  boot.loader.grub.enable = false;
  boot.loader.grub.device = "nodev";

  environment.noXlibs = false;

  swapDevices = [ ];

  networking = {
    hostName = "Proxmox-LXC";
    hostId = "79196719";

    #interfaces.enp4s0.useDHCP =  true;

    networkmanager.enable = true;

    wireless.enable = false;
  };

  services.chrony.enable = lib.mkForce false;

  systemd.mounts = [{
    where = "/sys/kernel/debug";
    enable = false;
  }];

  systemd.services.zfs-mount.enable = false;
}
