{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.tmux;
in {
  options.apps.tools.tmux = with types; {
    enable = mkBoolOpt false "Enable Tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      catppuccin.enable = true;
      historyLimit = 100000;
      plugins = with pkgs; [
        tmuxPlugins.sensible
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.yank
        tmuxPlugins.cpu
      ];
      extraConfig = ''
                set -g default-terminal "screen-256color"
        set -g prefix C-a
        unbind C-b
        bind-key C-a send-prefix


        unbind %
        bind | split-window -h

        unbind '"'
        bind - split-window -v

        unbind r
        bind r source-file ~/.tmux.conf

        bind -r j resize-pane -D 5
        bind -r k resize-pane -U 5
        bind -r l resize-pane -R 5
        bind -r h resize-pane -L 5

        bind -r m resize-pane -Z

        set -g mouse on


        set-window-option -g mode-keys vi

        unbind -T copy-mode-vi MouseDragEnd1Pane

        set-option -sg escape-time 10
        set-option -g focus-events on
        set-option -g renumber-windows on
        set -as terminal-features ",*:RGB"



                set-option -sa terminal-overrides ",xterm*:Tc"

                set -g base-index 1
                set -g pane-base-index 1
                setw -g mode-keys vi
                set-window-option -g pane-base-index 1
                set-option -g renumber-windows on

                set -g @catppuccin_window_left_separator ""
                set -g @catppuccin_window_right_separator " "
                set -g @catppuccin_window_middle_separator " █"
                set -g @catppuccin_window_number_position "right"
                set -g @catppuccin_window_default_fill "number"
                set -g @catppuccin_window_default_text "#W"
                set -g @catppuccin_window_current_fill "number"
                set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
                set -g @catppuccin_status_modules_right "directory meetings cpu date_time uptime"
                set -g @catppuccin_status_modules_left "session"
                set -g @catppuccin_status_left_separator  " "
                set -g @catppuccin_status_right_separator " "
                set -g @catppuccin_status_right_separator_inverse "no"
                set -g @catppuccin_status_fill "icon"
                set -g @catppuccin_status_connect_separator "no"
                set -g @catppuccin_directory_text "#{b:pane_current_path}"
                set -g @catppuccin_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
                set -g @catppuccin_date_time_text "%H:%M"

                bind-key -T copy-mode-vi v send-keys -X begin-selection
                bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
                bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

                bind '"' split-window -v -c "#{pane_current_path}"
                bind % split-window -v -c "#{pane_current_path}"
      '';
    };
  };
}
