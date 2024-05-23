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
    nixpkgs_stable.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager_stable = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs_stable";
    };

    resume.url = "git+https://git.zackmyers.io/zack/resume";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    ags.url = "github:Aylur/ags";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blog.url = "github:zackartz/zmio";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    kb-gui = {
      url = "github:zackartz/kb-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    rio-term = {
      url = "github:raphamorim/rio";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      snowfall = {
        namespace = "custom";
      };

      channels-config = {
        allowUnfree = true;
      };

      templates = import ./templates {};

      homes.modules = with inputs; [
        spicetify-nix.homeManagerModule
        catppuccin.homeManagerModules.catppuccin
        anyrun.homeManagerModules.default
        ags.homeManagerModules.default
      ];

      systems.modules.nixos = with inputs; [
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager
        catppuccin.nixosModules.catppuccin
        blog.nixosModule
        agenix.nixosModules.default
      ];
    };

  # outputs = {
  #   self,
  #   nixpkgs,
  #   nixpkgs_stable,
  #   systems,
  #   ...
  # } @ inputs: let
  #   eachSystem = f:
  #     nixpkgs.lib.genAttrs (import systems) (
  #       system:
  #         f nixpkgs.legacyPackages.${system}
  #     );
  # in {
  #   nixosConfigurations.pluto = nixpkgs_stable.lib.nixosSystem {
  #     specialArgs = {inherit inputs;};
  #     modules = [
  #       ./hosts/pluto/configuration.nix
  #       inputs.home-manager_stable.nixosModules.default
  #       inputs.blog.nixosModule
  #       inputs.agenix.nixosModules.default
  #     ];
  #   };
  #
  #   nixosConfigurations.earth = nixpkgs.lib.nixosSystem {
  #     specialArgs = {inherit inputs;};
  #     modules = [
  #       ./hosts/earth/configuration.nix
  #       inputs.lanzaboote.nixosModules.lanzaboote
  #       inputs.home-manager.nixosModules.default
  #       inputs.catppuccin.nixosModules.catppuccin
  #       inputs.agenix.nixosModules.default
  #     ];
  #   };
  #
  #   nixosConfigurations.live = nixpkgs.lib.nixosSystem {
  #     system = "x86_64-linux";
  #     specialArgs = {inherit inputs;};
  #     modules = [
  #       "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
  #       "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  #       # ./hosts/live/configuration.nix
  #     ];
  #   };
  #
  #   devShells = eachSystem (pkgs: {
  #     default = pkgs.mkShell {
  #       buildInputs = [
  #         pkgs.nixd
  #         pkgs.alejandra
  #         pkgs.stylua
  #         pkgs.lua-language-server
  #         pkgs.luajitPackages.lua-lsp
  #       ];
  #     };
  #   });
  # };
}
