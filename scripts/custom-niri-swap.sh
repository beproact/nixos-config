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
                def capitalize:
                    (.[0:1] | ascii_upcase) + .[1:];
                def force_size($n):
                    (.+(" " * $n))[:$n];
                sort_by(.workspace_id, .id)
                | [map(select([.workspace_id] | inside($ws))), map(select([.workspace_id] | (inside($ws) | not)))] | add
                | .[]
                | (.workspace_id|tostring)
                    + "\u2502"
                    + ((.app_id | split("."))[-1] | capitalize | force_size(10))
                    + "\u2502"

                    + (.title | force_size(47))
                    + "\u2502"
                    + (.id|tostring)
                    + "\u0000icon\u001f"
                    + icon
                    + ",application-x-executable"' -r\
        | $MENU --dmenu --placeholder="Swap to Window"\
        | jq -R 'split("\u2502")[-1] | tonumber'\
        | xargs -r niri msg action focus-window --id
