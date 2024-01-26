{ config, lib, pkgs, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.knot-resolver
  ];

  networking.nameservers = [ "127.0.0.1" "::1" ];
  networking.networkmanager.dns = lib.mkForce "none";

  services.kresd = { 
    enable = true;
    extraConfig = ''
-- Load useful modules
modules = {
        'hints > iterate',  -- Allow loading /etc/hosts or custom root hints
        'stats',            -- Track internal statistics
        'predict',          -- Prefetch expiring/frequent records
}

-- Cache size
cache.size = 100 * MB

modules.load('prefill')
prefill.config({
    ['.'] = {
        url = 'https://www.internic.net/domain/root.zone',
        interval = 86400, -- seconds
    }
})
    '';
    instances = 4;
  }; 
}
