{
  picom = {
    enable = true;
    opacityRule = [
      "95:class_g = 'st-256color'"
    ];
    blur = false;
    fade = true;
    shadow = false;
    backend = "xr_glx_hybrid";
  };

  dunst = import ./dunst.nix;

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

  lorri = {
    enable = true;
  };

  screen-locker = {
    enable = true;
    lockCmd = "/run/wrappers/bin/slock";
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
