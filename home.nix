{ config, pkgs, ...}:

{
    home.username = "snappy";
    home.homeDirectory = "/home/snappy";
    programs.git.enable = true;
    home.stateVersion = "25.11";
    programs.bash = {
        enable = true;
        shellAliases = {
            nrs = "sudo nixos-rebuild switch";
            btw = "echo banana";
            nrsf = "sudo nixos-rebuild switch --flake /home/snappy/.dotfiles/nixos/ --impure";
            nrsi = "sudo nixos-rebuild switch --flake . --impure";
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
        };
    };


}
