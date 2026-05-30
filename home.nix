{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "snappy";
  home.homeDirectory = "/home/snappy";
  programs.git.enable = true;
  home.stateVersion = "25.11";
  # home.backupFileExtension = "backup";

  home.packages = with pkgs; [
    (writeShellScriptBin "custom-niri-swap" (builtins.readFile ./scripts/niri-swap.sh))

    (writeShellScriptBin "custom-niri-harp" (builtins.readFile ./scripts/niri-harp.sh))
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch";
      btw = "echo waffle house";
      nrsf = "sudo nixos-rebuild switch --flake /home/snappy/.dotfiles/nixos/ ";
      hms = "home-manager switch -f /home/snappy/.dotfiles/nixos/home.nix";
    };
    sessionVariables = {
    };
    initContent = ''
      function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d ''' cwd < "$tmp"
          [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
          rm -f -- "$tmp"
      }
      eval "$(zoxide init --cmd cd zsh)"
    '';
  };

  programs.git = {
    # enable already set for some reason
    settings = {
      user = {
        name = "BeProact";
        email = "jasonalow8@gmail.com";
      };
      init.defaultBranch = "main";
      credential = {
        helper = "store";
        "https://github.com".username = "beproact";
        credentialStore = "cache";
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-feature = "-calt, -liga, -dlig";
      font-size = "10";
      shell-integration-features = "no-title";
      theme = "Tomorrow Night Bright";
      # wez also
    };
  };

  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 10;
    settings = {
      disable_ligatures = "always";
    };
  };

  programs.foot.enable = true;
  programs.foot.settings = {
    main.font = "JetBrainsMono Nerd Font:size=10";
    colors-dark = {
      foreground = "eaeaea";
      background = "000000";
      regular0 = "000000";
      regular1 = "d54e53";
      regular2 = "b9ca4a";
      regular3 = "e7c547";
      regular4 = "7aa6da";
      regular5 = "c397d8";
      regular6 = "70c0b1";
      regular7 = "ffffff";
      bright0 = "000000";
      bright1 = "d54e53";
      bright2 = "b9ca4a";
      bright3 = "e7c547";
      bright4 = "7aa6da";
      bright5 = "c397d8";
      bright6 = "70c0b1";
      bright7 = "ffffff";
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "ghostty -e {cmd}";
        # placeholder = "";
        horizontal-pad = "8";
        width = "70";
        tabs = "2";
        font = "JetBrainsMono Nerd Font";
      };
      colors = {
        background = "000000ff";
        text = "ffffffff";
        border = "ffffffff";
        selection = "ffffffff";
        selection-text = "000000ff";
      };
      border = {
        radius = "0";
      };
    };
  };
  programs.rofi = {
    enable = true;
    # package = pkgs.rofi-wayland;
    font = "JetBrainsMono Nerd Font 10";
    terminal = "\${pkgs.foot}/bin/foot";
  };

  services.mako = {
    enable = true;
    settings = {
      width = "500";
      height = "200";
      background-color = "#000000";
      border-color = "#FFFFFF";
      font = "JetBrainsMono Nerd Font 10";
      default-timeout = "5000";
    };
  };

  xdg.configFile."niri/config.kdl".source = ./configs/config.kdl;

  # wayland.windowManager.mango = {
  #   enable = true;
  # };

}
