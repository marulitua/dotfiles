{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "maruli";
  home.homeDirectory = "/home/maruli";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
#    # here is some command line tools I use frequently
#    # feel free to add your own or remove some of them
#
#    # networking tools
#    mtr # A network diagnostic tool
#    iperf3
#    dnsutils  # `dig` + `nslookup`
#    ldns # replacement of `dig`, it provide the command `drill`
#    aria2 # A lightweight multi-protocol & multi-source command-line download utility
#    socat # replacement of openbsd-netcat
#    nmap # A utility for network discovery and security auditing
#    ipcalc  # it is a calculator for the IPv4/v6 addresses
#
#    # misc
#    cowsay
#    file
#    which
#    tree
#    gnused
#    gnutar
#    gawk
#    zstd
#    gnupg
#
#    # nix related
#    #
#    # it provides the command `nom` works just like `nix`
#    # with more details log output
#    nix-output-monitor
#
#    btop  # replacement of htop/nmon
#    iotop # io monitoring
#    iftop # network monitoring
#
#    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
#
#    # system tools
#    sysstat
#    lm_sensors # for `sensors` command
#    ethtool
#    pciutils # lspci
#    usbutils # lsusb
    usbutils
    pciutils

    lshw
    mpv
    smplayer
    bat-extras.batgrep
    bat
    kitty
    delta
    d2
    broot

    tinymist
    typst
    websocat

    ansible-language-server
    ansible-lint

    ruff
    basedpyright

    lua-language-server
    bash-language-server
    terraform-ls

    go
    gopls

    nixd

    neofetch
    tokei
    xh
    asciinema

    gcc
    tree-sitter

    typescript-language-server

    phpactor
  ];

#  # basic configuration of git, please change to your own
#  programs.git = {
#    enable = true;
#    userName = "Ryan Yin";
#    userEmail = "xiaoyin_c@qq.com";
#  };
#
#  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
      cmd_duration = {
        show_notifications = true;
        min_time_to_notify = 3000;
      };
    };
  };
#
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.wezterm = {
    enable = true;
#    enableZshIntegration = true;
    enableBashIntegration = true;
#    extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
    extraConfig = builtins.readFile ../config/wezterm.lua;
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
       let carapace_completer = {|spans|
       carapace $spans.0 nushell ...$spans | from json
       }
       $env.config = {
        buffer_editor: "nvim",
        show_banner: false,
        completions: {
        case_sensitive: false # case-sensitive completions
        quick: true    # set to false to prevent auto-selecting completions
        partial: true    # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
        # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true
        # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100
            completer: $carapace_completer # check 'carapace_completer'
          }
        }
       }
       $env.PATH = ($env.PATH |
       split row (char esep) |
       prepend /home/maruli/.apps |
       append /usr/bin/env
       )
       '';
    shellAliases = {
       vi = "nvim";
       vim = "nvim";
       nano = "nvim";
       fg = "job unfreeze";
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.zellij = {
    enable = true;
    settings = {
      scroll_buffer_size = 1000000;
      scrollback_editor = "/run/current-system/sw/bin/nvim";
      default_shell = "nu";
    };
  };

#  programs.neovim.plugins = [
#    pkgs.vimPlugins.nvim-treesitter.withAllGrammars
#  ];
  programs.neovim = {
    enable = true;
#    package = pkgs.neovim-nightly;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

#    plugins = with pkgs.vimPlugins; [
#      lazy-nvim
#      which-key-nvim
#    ];
#
#    extraLuaConfig = ''
#      vim.g.mapleader = " " -- Need to set leader before lazy for correct keybindings
#      require("lazy").setup({
#        performance = {
#          reset_packpath = false,
#          rtp = {
#              reset = false,
#            }
#          },
#        dev = {
#          path = "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
#	  patterns = {""}, -- Specify that all of our plugins will use the dev dir. Empty string is a wildcard!
#        },
#        install = {
#          -- Safeguard in case we forget to install a plugin with Nix
#          missing = false,
#	  colorscheme = { "habamax" },
#        },
#        spec = {
#          -- import your plugins
#          { import = "plugins" },
#        },
#        checker = { enabled = true },
#      })
#    '';
  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = ./nvim_lua;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  fonts.fontconfig.enable = true;
}
