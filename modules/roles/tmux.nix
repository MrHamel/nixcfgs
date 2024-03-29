{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.tmux
    pkgs.tmux-mem-cpu-load
    pkgs.xclip
  ];

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
# split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# reload config file (change file location to your the tmux.conf you want to use)
bind r source-file /etc/tmux.conf

# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Enable mouse control (clickable windows, panes, resizable panes)
set -g mouse on

# Scroll terminal buffers, not command history
unbind -n MouseDrag1Pane

# Use xclip to copy and paste with the system clipboard
bind C-c run "tmux save-buffer - | xclip -i -sel clip"
bind C-v run "tmux set-buffer $(xclip -o -sel clip); tmux paste-buffer"

# General stuff
setw -g xterm-keys on
set -sg repeat-time 600                   # increase repeat timeout
set -s focus-events on
set -g renumber-windows on

set -g set-titles on          # set terminal title

#set -g display-panes-time 800 # slightly longer pane indicators display time
#set -g display-time 1000      # slightly longer status messages display time

#set -g status-interval 10     # redraw status line every 10 seconds

# activity
set -g monitor-activity on
set -g visual-activity on

set -g status-interval 2
set -g status-left "#S #[fg=green,bg=black]#(tmux-mem-cpu-load --colors --interval 2)#[default]"
set -g status-left-length 60

#set -g status-right-length 200
#set -g status-right "#{sysstat_cpu} | #{sysstat_mem} | #{sysstat_swap} | #{sysstat_loadavg} | #(echo $USER)@#H | %Y-%m-%d %H:%M #{tmux_mode_indicator}"
    '';
    historyLimit = 9999999;
    plugins = [
      pkgs.tmuxPlugins.better-mouse-mode
      pkgs.tmuxPlugins.mode-indicator
      pkgs.tmuxPlugins.resurrect
      pkgs.tmuxPlugins.sysstat
    ];
  };
}
