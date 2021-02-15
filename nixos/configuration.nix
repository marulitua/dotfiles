# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let php = pkgs.php.buildEnv { extraConfig = "memory_limit = 4G"; };

in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./common.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.grub.device = "/dev/sdb";
    kernelModules = [ "kvm-amd" "kvm-intel" ];
  };

  networking.hostName = "magnetar"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Makassar";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = false;
  networking.firewall.allowedTCPPorts = [ 8000 ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "FiraCode";
     keyMap = "us";
  };

  fonts.fonts = with pkgs; [
     fira-code
     fira-code-symbols
     hack-font
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maruli = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" "vboxusers" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  programs.zsh.enable = true;

#  programs.zsh.ohMyZsh = {
#     enable = true;
#     custom = "~/.oh-my-zsh/custom";
#     plugins = [
#     	"auto-notify"
#	"httpie"
#	"git"
#	"history"
#	"tmux"
#	"archlinux"
#	"vi-mode"
#	"zsh-autosuggestions"
#	"zsh-syntax-highlighting"
#	"rust"
#	"you-should-use"
#	"z"
#     ];
#  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";

    #Xmonad
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    displayManager.defaultSession = "none+xmonad";
    desktopManager.xterm.enable = false;

    #Gnome
    #desktopManager.gnome3.enable = true;

    displayManager.gdm.enable = true;
    wacom.enable = true;
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  services.gnome3.gnome-keyring.enable = true;

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    virtualbox.host = { 
      enable = true;
      headless = true;
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system = {
    stateVersion = "20.09"; # Did you read the comment?
    autoUpgrade.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     file
     smartmontools
     wget
     neovim
     htop
     tmux
     fzf
     firefox
     kitty
     exa
     git
     bat
     httpie
     starship
     direnv
     navi
     yarn
     dmenu
     xscreensaver
     openssl

     docker-compose
     docker-credential-helpers
     ansible

     pulseaudio
     pavucontrol

     ripgrep
     ripgrep-all

     rustup
     gcc
     mkpasswd

     libnotify
     dunst
     php
     python3
     python38Packages.pip
     nodejs
     ctags
     texlive.combined.scheme-medium

     unzip
     terraform-docs
     terraform-landscape

     broot
     inetutils
     act

     vagrant
     nomad

     python38Packages.paho-mqtt
     python38Packages.pylint

     asciinema
     jq
     watchexec
     chromium

     ccls
  ];
}
