{ config, pkgs, lib, ...}:

{
    home.username = "snappy";
    home.homeDirectory = "/home/snappy";
    programs.git.enable = true;
    home.stateVersion = "25.11";
    # home.backupFileExtension = "backup";
    programs.bash = {
        enable = true;
        shellAliases = {
            nrs = "sudo nixos-rebuild switch";
            btw = "echo waffle house";
            nrsf = "sudo nixos-rebuild switch --flake /home/snappy/.dotfiles/nixos/ --impure";
	    hms = "home-manager switch -f /home/snappy/.dotfiles/nixos/home.nix";
        };
	sessionVariables = {
	};
        initExtra =
            ''
                function y() {
                    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
                    yazi "$@" --cwd-file="$tmp"
                    IFS= read -r -d ''' cwd < "$tmp"
                    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
                    rm -f -- "$tmp"
                }
            '';
    };

    programs.git = { # enable already set for some reason
        settings = {
            user = {
                name  = "BeProact";
                email = "jasonalow8@gmail.com";
            };
            init.defaultBranch = "main";
        };
    };

    programs.ghostty = {
        enable = true;
        settings = {
            font-family = "JetBrainsMono Nerd Font";
	    shell-integration-features = "no-title";
	    theme = "Tomorrow Night Bright";
	    # wez also
        };
    };

    
    programs.fuzzel = {
	enable = true;
	settings = {
	    main = {
		terminal = "ghostty -e {cmd}";
		placeholder = "PIZZA HUT";
	    };
	};
    };
    
    xdg.configFile."niri/config.kdl".source = ./configs/config.kdl;

}
