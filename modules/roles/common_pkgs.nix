{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.bmon
    pkgs.curl
    pkgs.dmidecode
    pkgs.git
    pkgs.htop
    pkgs.iftop
    pkgs.iotop
    pkgs.jq
    pkgs.lsof
    pkgs.man
    pkgs.nmap
    pkgs.pciutils
    pkgs.pixz
    pkgs.poetry
    pkgs.python3
    pkgs.python3Packages.pip
    pkgs.python3Packages.virtualenv
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
