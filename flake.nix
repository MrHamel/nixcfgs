{
  description = "Ryan's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs2311.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
    };
  };

  outputs =
    { self
    , agenix
    , home-manager
    , nixos-generators
    , nixos-hardware
    , nixpkgs
    , nixpkgs2311
    , utils
    , ...
    } @ inputs: {
      nixosModules = import ./modules { lib = nixpkgs.lib; };
      nixosConfigurations = {
        hp = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/hp/configuration.nix
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            nixos-generators.nixosModules.all-formats
            utils.nixosModules.autoGenFromInputs
          ];
          specialArgs = { inherit inputs; };
        };
        hp_stripped = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/hp_stripped/configuration.nix
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            nixos-generators.nixosModules.all-formats
            utils.nixosModules.autoGenFromInputs
          ];
          specialArgs = { inherit inputs; };
        };
        proxmox_lxc = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/proxmox-lxc/configuration.nix
            <nixpkgs/nixos/modules/virtualisation/lxc-container.nix>
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            nixos-generators.nixosModules.all-formats
            utils.nixosModules.autoGenFromInputs
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
