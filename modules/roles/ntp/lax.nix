{
  imports = [
    ./main.nix
  ];

  time.timeZone = "America/Los_Angeles";

  networking.timeServers = [ "time5.facebook.com" "uslax1-ntp-002.aaplimg.com" "ussjc2-ntp-001.aaplimg.com" "time3.facebook.com" ];
}
