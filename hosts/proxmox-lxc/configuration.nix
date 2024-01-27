{ config, pkgs, inputs, ... }:

{
  imports = with inputs.self.nixosModules;
    [
      <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
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

  # Install new init script
  system.activationScripts.installInitScript = lib.mkForce ''
    mkdir -p /sbin
    ln -fs $systemConfig/init /sbin/init
  '';

  swapDevices = [ ];

  networking = {
    hostName = "Proxmox-LXC";
    hostId = "79196719";

    #interfaces.enp4s0.useDHCP =  true;

    networkmanager.enable = true;

    wireless.enable = false;
  };

  systemd.services.zfs-mount.enable = false;
}
