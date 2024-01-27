{ config, lib, pkgs, inputs, ... }:

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

  swapDevices = [ ];

  networking = {
    hostName = "Proxmox-LXC";
    hostId = "79196719";

    useDHCP = lib.mkForce false;
    wireless.enable = false;
  };

  programs.zsh = { 
    shellAliases = {
      "update" = lib.mkForce "doas nixos-rebuild switch --impure --flake /etc/nixos#proxmox_lxc";
    };
  };

  services.chrony.enable = lib.mkForce false;
  services.resolved.enable = false;

  systemd.mounts = [{
    where = "/sys/kernel/debug";
    enable = false;
  }];

  systemd.network.enable = true;

  systemd.network.networks."10-WAN" = {
    # match the interface by name
    matchConfig.Name = "eth0";
    address = [
        # configure addresses including subnet mask
        "173.254.236.54/29"
    ];
    routes = [
      { routeConfig.Gateway = "173.254.236.49"; }
    ];
    # make the routes on this interface a dependency for network-online.target
    linkConfig.RequiredForOnline = "no";
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  systemd.services.zfs-mount.enable = false;
}
