#!/bin/sh

MENU=fuzzel
dmen () {
    $MENU --dmenu --placeholder='Swap Window'
}


WINDOWS="$(niri msg -j windows)"
LONG="$(echo "$WINDOWS" | jq -r '[.[].app_id | split(".") | last |length] | max')"
ACTIVE="$(niri msg -j workspaces| jq '[.[] | select(.is_active==true) | .id]' -c)"
pkill "$MENU" ||\
    echo "$WINDOWS"\
        | jq --argjson ws "$ACTIVE"\
            --argjson long "$LONG"\
            -r \
            '
                def icon:
                    if .app_id | test("ghostty") then "com.mitchellh.ghostty"
                    else (.app_id | split(".") | last)
                    end;
                def capitalize:
                    (.[:1] | ascii_upcase) + .[1:];
                def force_size($n):
                    (.+(" " * $n))[:$n];
                sort_by(.workspace_id, .id)
                | [map(select([.workspace_id] | inside($ws))), map(select([.workspace_id] | (inside($ws) | not)))]
		| add
                | .[]
                | (.workspace_id|tostring)
                    + "\u2502"
                    + ((.app_id | split("."))[-1] | capitalize | force_size($long))
                    + "\u2502"
                    + (.title)
                    + "\u200C"
                    + ("\u200B" * .id)
                    + "\u0000icon\u001f"
                    + icon
                    + ",application-x-executable"
            '\
        | dmen \
        | jq -R '(split("\u200C")[-1]) | length'\
        | xargs -r niri msg action focus-window --id

# keeps track of id by number of invisible \u200B characters which is stupid but works
