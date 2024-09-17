{
  pkgs,
  lib,
  system,
  inputs,
  config,
  ...
}: {
  imports = [./hardware-configuration.nix];

  hardware.audio.enable = true;
  hardware.nvidia.enable = true; # Enable if you have a nvidia GPU
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  ui.fonts.enable = true;

  protocols.wayland.enable = true;

  services.fstrim.enable = true; # Optional, improve SSD lifespan
  services.xserver.enable = true; # Optional, but recommended (allows XWayland to work)
  services.gnome.gnome-keyring.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "johnster"; # Define your hostname. MUST BE THE SAME AS THE HOSTNAME YOU SPECIFIED EARLIER!!!

  # services.openssh = {
  #   enable = true;
  #   PasswordAuthentication = true;
  # };

  time.timeZone = "America/Detroit"; # Change to your TZ

  programs.zsh.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  # REMEMBER TO CHANGE TO YOUR USERNAME
  users.users.john = {
    isNormalUser = true;
    description = "john";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.zsh;
  };

  virtualisation.docker.enable = true;

  # CHANGE USERNAME HERE TOO
  snowfallorg.users.john = {
    create = true;
    admin = false;

    home = {
      enable = true;
    };
  };

  catppuccin.enable = true; # If you want your TTY to be catppuccin too haha

  environment.systemPackages = with pkgs; [
    custom.vesktop
  ];
}
