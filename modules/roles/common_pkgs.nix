{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.bmon
    pkgs.coreutils
    pkgs.curl
    pkgs.dmidecode
    pkgs.dnsutils
    pkgs.ethtool
    pkgs.file
    pkgs.findutils
    pkgs.gawk
    pkgs.git
    pkgs.gnused
    pkgs.htop
    pkgs.iftop
    pkgs.inetutils
    pkgs.iotop
    pkgs.jq
    pkgs.less
    pkgs.lshw
    pkgs.lsof
    pkgs.man
    pkgs.micro
    pkgs.nmap
    pkgs.openssl
    pkgs.pciutils
    pkgs.pixz
    pkgs.poetry
    pkgs.procps
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.python3Packages.virtualenv
    pkgs.rclone
    pkgs.rsync
    pkgs.screen
    pkgs.smartmontools
    pkgs.tmux
    pkgs.traceroute
    pkgs.unzip
    pkgs.usbutils
    pkgs.vim-full
    pkgs.wget
    pkgs.whois
    pkgs.xz
    pkgs.zip
  ];

}
