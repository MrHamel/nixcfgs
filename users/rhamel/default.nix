{ config, lib, pkgs, inputs, headless ? true, ... }:

{
  home = {
    username = "rhamel";
    homeDirectory = "/home/rhamel";
    stateVersion = "23.11";
  };

  imports = [
    ./tmux.nix
  ];

  programs = {
    git = {
      enable = true;
      userName  = "Ryan Hamel";
      userEmail = "ryan@rkhtech.org";
    };
  };

  xdg.configFile = {
    "micro/plug/monokai-dark/monokai-dark.lua".text =
    ''
VERSION = "0.1.0"

AddRuntimeFile("monokai-dark", "colorscheme", "monokai-dark.micro")
'';

    "micro/plug/monokai-dark/monokai-dark.micro".text = 
    ''
color-link default "#D5D8D6,#1D0000"
color-link comment "#75715E"
color-link identifier "#66D9EF"
color-link constant "#AE81FF"
color-link constant.string "#E6DB74"
color-link constant.string.char "#BDE6AD"
color-link statement "#F92672"
color-link preproc "#CB4B16"
color-link type "#66D9EF"
color-link special "#A6E22E"
color-link underlined "#D33682"
color-link error "bold #CB4B16"
color-link todo "bold #D33682"
color-link statusline "#282828,#F8F8F2"
color-link indent-char "#505050,#282828"
color-link line-number "#AAAAAA,#282828"
color-link current-line-number "#AAAAAA,#282828"
color-link gutter-error "#CB4B16"
color-link gutter-warning "#E6DB74"
color-link cursor-line "#323232"
color-link color-column "#323232"
'';


    "micro/plug/monokai-dark/repo.json".text = 
    ''
[{
  "Name": "monokai-dark",
  "Description": "A dark monokai colorscheme for micro",
  "Tags": ["colorscheme"],
  "Versions": [
    {
      "Version": "0.1.0",
      "Url": "https://github.com/theodus/monokai-dark/archive/0.1.0.zip",
      "Require": {
        "micro": ">=1.1.3"
      }
    }
  ]
}]
'';

    "micro/settings.json".text = 
    ''
{
    "colorscheme": "monokai-dark"
}
'';

  };
}
