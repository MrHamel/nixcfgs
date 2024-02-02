{ config, lib, pkgs, inputs, ... }:

{
  imports = with inputs.self.nixosModules;
    [
      ./hardware-configuration.nix
      groups-workstation
      ../../modules/roles/ntp/lax.nix
    ];

  # Restore ssh host and user keys if they are available.
  # This avoids warnings of unknown ssh keys.
  boot.initrd.postMountCommands = ''
    mkdir -m 700 -p /mnt-root/root/.ssh
    mkdir -m 755 -p /mnt-root/etc/ssh
    mkdir -m 755 -p /mnt-root/root/network
    if [[ -f ssh/authorized_keys ]]; then
      install -m 400 ssh/authorized_keys /mnt-root/root/.ssh
    fi
    install -m 400 ssh/ssh_host_* /mnt-root/etc/ssh
    cp *.json /mnt-root/root/network/
    if [[ -f machine-id ]]; then
      cp machine-id /mnt-root/etc/machine-id
    fi
  '';

  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "console=tty0" ] ++
    (lib.optional (pkgs.stdenv.hostPlatform.isAarch32 || pkgs.stdenv.hostPlatform.isAarch64) "console=ttyAMA0,115200") ++
    (lib.optional (pkgs.stdenv.hostPlatform.isRiscV) "console=ttySIF0,115200") ++
    [ "console=ttyS0,115200" ];

  boot.loader.grub.enable = false;
  #boot.loader.grub.device = "nodev";

  environment.noXlibs = false;

  swapDevices = [ ];

  networking = {
    hostName = "";
    hostId = "19390138";

    useDHCP = lib.mkForce true;
    wireless.enable = false;
  };

  programs.zsh = { 
    shellAliases = {
      "update" = lib.mkForce "doas nixos-rebuild switch --upgrade-all --impure --flake /etc/nixos#pxe";
    };
  };

  #services.chrony.enable = true;
  #services.resolved.enable = false;

  # overrides normal activation script for setting hostname
  system.activationScripts.hostname = lib.mkForce ''
    # apply hostname from cmdline
    for o in $(< /proc/cmdline); do
      case $o in
        hostname=*)
          IFS== read -r -a hostParam <<< "$o"
          ;;
      esac
    done
    hostname "''${hostParam[1]:-nixos}"
  '';

  system.build.netboot = pkgs.symlinkJoin {
    name = "netboot";
    paths = with config.system.build; [
      netbootRamdisk
      kernel
      (pkgs.runCommand "kernel-params" { } ''
        mkdir -p $out
        ln -s "${config.system.build.toplevel}/kernel-params" $out/kernel-params
        ln -s "${config.system.build.toplevel}/init" $out/init
      '')
    ];
    preferLocalBuild = true;
  };

  # Don't add nixpkgs to the image to save space, for our intended use case we don't need it
  system.installer.channel.enable = false;

  #systemd.network.enable = true;

  systemd.services.log-network-status = {
    wantedBy = [ "multi-user.target" ];
    # No point in restarting this. We just need this after boot
    restartIfChanged = false;

    serviceConfig = {
      Type = "oneshot";
      StandardOutput = "journal+console";
      ExecStart = [
        # Allow failures, so it still prints what interfaces we have even if we
        # not get online
        "-${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online"
        "${pkgs.iproute2}/bin/ip -c addr"
        "${pkgs.iproute2}/bin/ip -c -6 route"
        "${pkgs.iproute2}/bin/ip -c -4 route"
        "${pkgs.systemd}/bin/networkctl status"
      ];
    };
  };

  #systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  systemd.services.zfs-mount.enable = false;
}
