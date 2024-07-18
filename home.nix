{ config, lib, pkgs, ... }:
let mod = "Mod4";
in {
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    emacs
    firefox
    vim
    git
    htop
    mpv
    tree
    alacritty
    wget
    libgccjit
    libgcc
    pavucontrol
    weston
    vulkan-tools
    clinfo
    nvtopPackages.amd
    glxinfo
    python3
    yazi
    unzip
    docker-compose
  ];

  programs = {
    nushell = {
      enable = true;
      configFile.source = "/home/lucas/.config/nushell/config.nu";
    };
    rofi.enable = true;
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = mod;
      gaps = {
        inner = 10;
        outer = 5;
      };
      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${mod}+Return" = "exec alacritty";
      };
    };
  };

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  home.sessionVariables = {
    EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
