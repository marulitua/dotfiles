# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "magnetar"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  networking.hosts = {
    "192.168.178.145" = ["imig.duckdns.org"];
  };

  # Set your time zone.
  time.timeZone = "Asia/Makassar";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Minimal configuration for NFS support with Vagrant.
  services.nfs.server.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "modesetting" "nvidia" ];
    displayManager = {
      defaultSession = "niri";
      gdm = {
        enable = true;
        wayland = true;
      };
    };
    desktopManager.gnome = {
      enable = true;
    };

  # Configure keymap in X11
    xkb.layout = "us";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.maruli = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "libvirtd" "audio" ]; # Enable ‘sudo’ for the user.
#    shell = pkgs.nushell;
#    shell = pkgs.bash;
  };

  security.sudo = {
    wheelNeedsPassword = false;
  };

  users.extraGroups.vboxusers.members = [ "maruli" ];

  programs.firefox.enable = true;

  # services.gnome.gnome-keyring.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];
  environment.systemPackages = with pkgs; [
    zip
    git
    wget
    curl
    htop
    nvtopPackages.full
    ripgrep
    zenith-nvidia
    file
    vagrant
    gimp
    watchexec
    font-awesome
    helix
    xclip

    lua51Packages.luarocks
    lua51Packages.lua
    eza
    fzf
    lshw
    jq

    sniffnet

    libreoffice

    wl-clipboard
  ];

  fonts.fontconfig.useEmbeddedBitmaps = true;

  fonts.packages = with pkgs; [
    google-fonts
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.symbols-only
    nerd-fonts.hack
    nerd-fonts.lilex
    nerd-fonts.monoid
    nerd-fonts.ubuntu-sans
    nerd-fonts.ubuntu-mono
    nerd-fonts.droid-sans-mono
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = ["maruli"];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.tcpdump.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # virtualization
  virtualisation = {
    docker = {
      enable = true;
      daemon.settings.features.cdi = true;
    };

    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };

    libvirtd.enable = true;

    spiceUSBRedirection.enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Add firewall exception for VirtualBox provider
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';

  # Add firewall exception for libvirt provider when using NFSv4
  networking.firewall.interfaces."virbr1" = {
    allowedTCPPorts = [ 2049 ];
    allowedUDPPorts = [ 2049 ];
  };

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
  system.stateVersion = "25.05"; # Did you read the comment?

  programs.adb.enable = true;

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["maruli"];

  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/mutter" = {
          experimental-features = [
            "scale-monitor-framebuffer" # Enables fractional scaling (125% 150% 175%)
            "variable-refresh-rate" # Enables Variable Refresh Rate (VRR) on compatible displays
            "xwayland-native-scaling" # Scales Xwayland applications to look crisp on HiDPI screens
          ];
        };
      };
    }
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    NIXOS_OZONE_WL = "1";
  };

  programs.niri.enable = true;
}
