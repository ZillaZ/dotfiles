# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot"; }
    ];
  };

  fileSystems."/" = {
    device = "zpool/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zpool/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "zpool/var";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12A4-9445";
    fsType = "vfat";
  };

  swapDevices = [ ];
  networking.hostName = "lucas"; # Define your hostname.
  networking.hostId = "2c8661f9";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Brazil/Sao_Paulo"; 

  virtualisation.waydroid.enable = true;
  boot.kernelParams = [ "amdgpu.runpm=0" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  environment.variables = {
    ROC_ENABLE_PRE_VEGA = "1";
  };
  environment.pathsToLink = [ "/libexec" ];  

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
	i3blocks
      ];
    };
  };
  services.displayManager.defaultSession = "none+i3";

  # Configure keymap in X11
  services.xserver.xkb.layout = "br";
  services.xserver.xkb.model = "abnt2";  
  services.pipewire = {
     enable = true;
     pulse.enable = true;
  };

  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lucas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.nushell;
    packages = with pkgs; [
      firefox
      tree
      emacs
      alacritty
      wget
      git
    ];
  };

   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     emacs
     firefox
     alacritty
     ripgrep
     coreutils
     fd
     clang
     nushell
     clinfo 
     vulkan-tools
  ];

  
  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "bfc8f6edcb7bcf3cf24e4a7199b3f6fed96aaecf"; # change the revision
    }))
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

