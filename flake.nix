{
  description = "Snappy";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    {
      nixosConfigurations.snix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.snappy = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
          {
            nixpkgs.overlays = [
              nur.overlays.default
            ];
          }
          inputs.mangowm.nixosModules.mango
        ];

        # specialArgs = {
        #   pkgs-unstable = import nixpkgs-unstable {
        #     system = "x86_64-linux";
        #     config.allowUnfree = true;
        #   };
        # };

      };
    };
}
