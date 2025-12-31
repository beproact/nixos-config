#!/bin/sh
MENU=fuzzel
pkill $MENU ||\
    niri msg -j windows\
        | jq --argjson ws\
            "$(niri msg -j workspaces| jq '
                [.[] | select(.is_active==true) | .id]
            '\
            -c)"\
            '
                def icon:
                    if .app_id | test("ghostty") then "com.mitchellh.ghostty"
                    else (.app_id | split(".") | last)
                    end;
                sort_by(.workspace_id, .id)
                | [map(select([.workspace_id] | inside($ws))), map(select([.workspace_id] | (inside($ws) | not)))] | add
                | .[]
                | (.workspace_id|tostring)
                    + "\u2502"
                    + .title
                    + "\u2502"
                    + (.app_id | split("."))[-1]
                    + "\u2502 "
                    + (.id|tostring)
                    + "\u0000icon\u001f"
                    + icon
                    + ",application-x-executable"' -r\
        | $MENU --dmenu\
        #| jq -R 'split(":")[-1] | tonumber'\
        #| xargs -r niri msg action focus-window --id
