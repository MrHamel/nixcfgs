{ config, pkgs, inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = import "${inputs.self}/users";
    extraSpecialArgs = {
      inherit inputs;
      headless = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    # From flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
    optimise.automatic = true;
    optimise.dates = [ "03:45" ];
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.command-not-found.enable = true;

  services.cron = {
    enable = true;
  };

  #system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
}
