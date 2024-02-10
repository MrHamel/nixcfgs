{ config, pkgs, inputs, ... }:
{
  imports = with inputs.self.nixosModules; [
      roles-common_pkgs
      roles-boilerplate
      roles-dns_resolver_internal
      roles-firewall
      roles-lldp
      roles-sshd
      roles-sudo
      roles-tmux
      roles-zfs
      roles-zsh
      users-rhamel
    ];
}
