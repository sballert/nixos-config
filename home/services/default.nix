{
  compton = {
    enable = true;
    opacityRule = [
      "95:class_g = 'st-256color'"
    ];
    blur = false;
    fade = true;
    shadow = false;
  };

  dunst = {
    enable = true;
    settings = {
      global = {
        font = "Noto Sans Display 10";
        markup = "yes";
        plain_text = "no";

        format = "<b>%s</b>\n%b";
        sort = "no";
        indicate_hidden = "yes";
        alignment = "center";
        bounce_freq = 0;
        show_age_threshold = -1;
        word_wrap = "yes";
        ignore_newline = "no";
        stack_duplicates = "yes";
        hide_duplicates_count = "yes";

        geometry = "300x50-15+49";
        shrink = "no";
        transparency = 0;
        idle_threshold = 0;
        monitor = 0;
        follow = "none";
        sticky_history = "no";
        history_length = 15;
        show_indicators = "no";
        line_height = 3;
        separator_height = 2;
        padding = 6;
        horizontal_padding = 6;
        separator_color = "frame";
        startup_notification = "false";
        icon_position = "off";
        max_icon_size = 80;

        frame_color = "#928374";
        frame_width = 1;
      };
      urgency_low = {
        foreground = "#ebdbb2";
        background = "#3c3836";
        timeout = 3;
      };
      urgency_normal = {
        foreground = "#ebdbb2";
        background = "#3c3836";
        timeout = 5;
      };
      urgency_critical = {
        foreground = "#ebdbb2";
        background = "#3c3836";
      };
    };
  };

  flameshot = {
    enable = true;
  };

  gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  screen-locker = {
    enable = true;
    lockCmd = "slock";
  };

  udiskie = {
    enable = true;
    tray = "never";
  };

  unclutter = {
    enable = true;
  };

  xcape = {
    enable = true;
    mapExpression = {
      Control_L = "Escape";
    };
  };

}
