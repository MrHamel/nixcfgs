{
  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    expandOnBoot = "all";
  };
}
