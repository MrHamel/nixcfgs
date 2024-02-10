{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.doas
#    pkgs.doas-sudo-shim
  ];

  security.doas = {
    enable = true;
  };

  security.sudo.enable = true;
}
