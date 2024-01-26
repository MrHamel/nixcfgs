{ config, inputs, ... }:
let
in
{
  nix.settings.trusted-users = [ "rhamel" ];
  users.users.rhamel = {
    extraGroups = [
      "wheel"
    ];
    hashedPassword = "$6$wk1ToaSAS4AyZ756$tLbS3he803cnjMW/VAuxTNU7qRajAKtZ4jS2GK4jKccZhBH4xXlFpoG02WVWcdCrtSrzcVbx0Io/yTWjpKz4M/";
    isNormalUser = true;
    #openssh.authorizedKeys.keys = keys.rhamel;
  };
}
