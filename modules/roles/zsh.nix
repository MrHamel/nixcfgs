{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.eza
    pkgs.fzf
    pkgs.neofetch
  ];

  programs.zsh = { 
    enable = true;
    histSize = 10000;
    interactiveShellInit = ''
neofetch
    '';
    shellAliases = {
      "400" = "chmod 400";
      "600" = "chmod 600";
      "644" = "chmod 644";
      "700" = "chmod 700";
      "750" = "chmod 750";
      "755" = "chmod 755";
      "777" = "chmod 777";
      "chrony-stats" = "chronyc tracking; chronyc sources; chronyc sourcestats -v";
      "kk" = "ll";
      "ll" = "eza --no-permissions --octal-permissions -1a@lFhg --color-scale --color=always --sort name";
      "ls" = "eza --no-permissions --octal-permissions -1a@lFhg --color-scale --color=always --sort name";
      "mtr" = "mtr -bezo LDRSNBAJMX";
      "scp" = "scp -rp";
      "screen" = "screen -L";
      "su" = "su -m -s";
      "wget" = "wget --server-response --progress=bar";
      "update" = "doas nixos-rebuild switch";
    };
  };

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "command-not-found" "common-aliases" "cp" "dirhistory" "encode64" "git" "gitignore" "git-extras" "history" "jsontools" "per-directory-history" "pip" "poetry" "poetry-env" "profiles" "pylint" "python" "redis-cli" "screen" "sudo" "systemd" "themes" "tmux" "urltools" "wd" "zsh-interactive-cd" ];
    theme = "candy";
  };

  users.defaultUserShell = pkgs.zsh;
}
