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

  swapDevices = [ ];

  networking = {
    hostName = "RKHTech-NixOS-Image";
    hostId = "36959201";

    #interfaces.enp4s0.useDHCP =  true;

    networkmanager.enable = true;

    wireless.enable = false;
  };

  systemd.services.zfs-mount.enable = false;
}
