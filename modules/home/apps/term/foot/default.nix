{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.term.foot;
in {
  options.apps.term.foot = with types; {
    enable = mkBoolOpt false "Enable Foot Terminal";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
    };
  };
}
