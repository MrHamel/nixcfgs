{
  services.openssh = { 
    enable = true;
    openFirewall = true;
    settings.PermitRootLogin = "yes";
  };
}
