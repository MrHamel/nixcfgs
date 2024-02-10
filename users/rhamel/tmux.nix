{ config, pkgs, inputs, ... }:
{
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
# split panes using v and h
bind h split-window -h
bind v split-window -v
unbind '"'
unbind %

# reload config file (change file location to your the tmux.conf you want to use)
bind r source-file /etc/tmux.conf

# Redraw the client (if interrupted by wall, etc)
bind R refresh-client

# Synchronize command toggle to all panes: [s]
bind-key s set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"

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

set -g status on

# Enable F3 to disable/enable inner/outer session bind-key grabbing while using nested tmux sessions
#--------------------------------------------------------------------------------------------------#
# Named color codes for status alteration
color_orange="colour166" # 208, 166
color_purple="colour134" # 135, 134
color_green="colour076" # 070
color_blue="colour39"
color_yellow="colour220"
color_red="colour160"
color_black="colour232"
color_white="white" # 015

# Color symlinks for status alteration
color_dark="$color_black"
color_light="$color_white"
color_session_text="$color_blue"
color_status_text="colour245"
color_main="$color_orange"
color_secondary="$color_purple"
color_level_ok="$color_green"
color_level_warn="$color_yellow"
color_level_stress="$color_red"
color_window_off_indicator="colour088"
color_window_off_status_bg="colour238"
color_window_off_status_current_bg="colour254"

# =====================================
# ===    Appearence and status bar  ===
# ======================================

set -g mode-style "fg=default,bg=$color_main"

# command line style
set -g message-style "fg=$color_main,bg=$color_dark"

# status line style
set -g status-style "fg=$color_status_text,bg=$color_dark"

# window segments in status line
set -g window-status-separator ""
separator_powerline_left="<"
separator_powerline_right=">"

# setw -g window-status-style "fg=$color_status_text,bg=$color_dark"
setw -g window-status-format " #I:#W "
setw -g window-status-current-style "fg=$color_light,bold,bg=$color_main"
setw -g window-status-current-format "#[fg=$color_dark,bg=$color_main]$separator_powerline_right#[default] #I:#W# #[fg=$color_main,bg=$color_dark]$separator_powerline_right#[default]"

# when window has monitoring notification
setw -g window-status-activity-style "fg=$color_main"

# outline for active pane
setw -g pane-active-border-style "fg=$color_main"

# -------------------------------------------------------------------------------------------------#

# Toggle nested/remote prefix ON
bind -T root F3  \
  set prefix None \;\
  set key-table off \;\
  set status-style "fg=$color_status_text,bg=$color_window_off_status_bg" \;\
  set window-status-current-format "#[fg=$color_window_off_status_bg,bg=$color_window_off_status_current_bg]$separator_powerline_right#[default] #I:#W# #[fg=$color_window_off_status_current_bg,bg=$color_window_off_status_bg]$separator_powerline_right#[default]" \;\
  set window-status-current-style "fg=$color_dark,bold,bg=$color_window_off_status_current_bg" \;\
  if -F '#{pane_in_mode}' 'send-keys -X cancel' \;\
  refresh-client -S \;\

# Toggle nested/remote prefix OFF
bind -T off F3 \
  set -u prefix \;\
  set -u key-table \;\
  set -u status-style \;\
  set -u window-status-current-style \;\
  set -u window-status-current-format \;\
  refresh-client -S

# -------------------------------------------------------------------------------------------------#

# Set parent terminal title to reflect current window in tmux session 
set -g set-titles on
set -g set-titles-string "#H - T_S: #S"

# -------------------------------------------------------------------------------------------------#

# activity
setw -g monitor-activity on
set -g visual-activity off

set -g status-interval 2
set -g status-left "Session: #S - #[fg=green,bg=black]#(tmux-mem-cpu-load -p -q -v -l 52 -r 33 -c -m 2 -i 2)#[default] - "
set -g status-left-length 200

set -g status-right-length 200
set -g status-right "#[fg=white,bg=red]#(echo $USER)@#H | %Y-%m-%d %H:%M"
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
