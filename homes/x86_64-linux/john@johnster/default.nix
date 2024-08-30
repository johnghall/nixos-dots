{
  inputs,
  pkgs,
  system,
  lib,
  ...
}: {
  wms.hyprland.enable = true; # Hyprland is the only fully-supported window manager in my config atm.
  apps = {
    web.librewolf.enable = true; # can also use firefox
    web.librewolf.setDefault = true;
    web.firefox.enable = true;

    tools.git.enable = true;
    tools.tmux.enable = true;
    tools.neovim.enable = true;
    tools.skim.enable = true;
    tools.starship.enable = true;
    tools.direnv.enable = true;
    tools.tealdeer.enable = true;
    tools.bat.enable = true;

    tools.gh.enable = true;

    term.kitty.enable = true;
    term.foot.enable = true;
    term.rio.enable = true;

    helpers = {
      anyrun.enable = true;
      ags.enable = true;
    };
  };

  shells.zsh.enable = true;

  rice.gtk.enable = true;

  services.lock.enable = true;

  xdg.enable = true;

  programs = {
    gpg.enable = true;
    man.enable = true;
    eza.enable = true;
    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  catppuccin.enable = true;
  catppuccin.flavor = "macchiato";
  catppuccin.accent = "pink";

  # Add any packages you want in your path here!
  home.packages = [
    pkgs.ungoogled-chromium

    pkgs.postman
    pkgs.mosh

    pkgs.dconf
    pkgs.wl-clipboard
    pkgs.pavucontrol
    pkgs.wlogout
    pkgs.sway-audio-idle-inhibit
    pkgs.grim
    pkgs.slurp

    pkgs.xfce.thunar
    pkgs.feh
    pkgs.nitch
    pkgs.nix-output-monitor

    pkgs.nh
    pkgs.dwl

    pkgs.custom.rebuild
    pkgs.custom.powermenu
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.cava.enable = true;

  programs.btop = {
    enable = true;
    extraConfig = ''
      update_ms = 100
      vim_keys = true
    '';
  };

  programs.lazygit.enable = true;
  programs.fzf.enable = true;

  systemd.user.services.xwaylandvideobridge = {
    Unit = {
      Description = "Tool to make it easy to stream wayland windows and screens to exisiting applications running under Xwayland";
    };
    Service = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.xwaylandvideobridge;
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
      enableSshSupport = true;
      enableZshIntegration = true;
    };
  };
}
