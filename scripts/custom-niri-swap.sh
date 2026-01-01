#!/bin/sh

MENU=fuzzel
dmen () {
    $MENU --dmenu --placeholder='Swap Window'
}



WINDOWS="$(niri msg -j windows)"
WORK="$(niri msg -j workspaces)"
LONG="$(echo "$WINDOWS" | jq -r '[.[].app_id | split(".") | last |length] | max')"
LONGID="$(echo $WORK | jq "([.[] | .idx ]| max - 1 | tostring | length)")" # Subtracting by 1 cause niri has extra workspace for when you add one
ACTIVE="$(echo $WORK | jq '[.[] | select(.is_active==true) | .id]' -c)"
echo $LONGID
swap () {
    pkill "$MENU" ||\
        echo "$WINDOWS"\
            | jq --argjson ws "$ACTIVE"\
                --argjson long "$LONG"\
                --argjson lid "$LONGID"\
                --argjson wk "$WORK"\
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
                    | (
                        .workspace_id
                        |. as $in | $wk | map(select(.id==$in)).[].idx
                        | tostring
                        | force_size($lid)
                        )
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
}
swap
# keeps track of id by number of invisible \u200B characters which is stupid but works
