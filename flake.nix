{
    description = "Snappy";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-25.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
	nur = {
	    url = "github:nix-community/NUR";
	    inputs.nixpkgs.follows = "nixpkgs";
	};
    };

    outputs = {self, nixpkgs, home-manager, nur, ...} : {
        nixosConfigurations.snix = nixpkgs.lib.nixosSystem{
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
		{ nixpkgs.overlays = [ nur.overlays.default ]; }
            ];
        };
    };
}
