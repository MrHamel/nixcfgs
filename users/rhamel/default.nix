{ config, lib, pkgs, inputs, headless ? true, ... }:

{
  home = {
    username = "rhamel";
    homeDirectory = "/home/rhamel";
    stateVersion = "23.11";
  };

  programs = {
    git = {
      enable = true;
      userName  = "Ryan Hamel";
      userEmail = "ryan@rkhtech.org";
    };
  };
}
