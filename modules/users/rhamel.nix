{ config, inputs, ... }:
let
in
{
  nix.settings.trusted-users = [ "rhamel" ];

  security.doas.extraRules = [
    { users = [ "rhamel" ]; keepEnv = true; }
  ];

  users.users.rhamel = {
    extraGroups = [
      "wheel"
    ];
    hashedPassword = "$6$wk1ToaSAS4AyZ756$tLbS3he803cnjMW/VAuxTNU7qRajAKtZ4jS2GK4jKccZhBH4xXlFpoG02WVWcdCrtSrzcVbx0Io/yTWjpKz4M/";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZ7GXc68qxUV2b+LXu2AG0rfqmVGq8HVc5ntnPFzP3P"
    ];
  };
}
