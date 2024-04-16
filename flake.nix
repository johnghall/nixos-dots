{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://zackartz.cachix.org"
    ];
    extra-trusted-public-keys = [
      "zackartz.cachix.org-1:nrEfVZF8MVX0Lnt73KwYzH2kwDzFuAoR5VPjuUd4R30="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kb-gui = {
      url = "github:zackartz/kb-gui";
    };

    waybar = {
      url = "github:Alexays/Waybar";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    rio-term = {
      url = "github:zackartz/rio";
    };

    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f nixpkgs.legacyPackages.${system}
      );
  in {
    nixosConfigurations.earth = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/earth/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.nil
          pkgs.stylua
          pkgs.nodePackages.coc-sumneko-lua
          pkgs.luajitPackages.lua-lsp
        ];
      };
    });
  };
}
