#!/bin/sh
TERMINAL="foot"
PAT="/tmp/"

input () {
    [ ! -z "$LET" ] && echo "$LET Exists" && key="${LET}reg.temp" && return

    TEMP="$(mktemp)"
    COMM='
        echo WHAT
        read -n 1 key
        echo $key > '
    $TERMINAL -e sh -c "$COMM$TEMP"
    while [ ! -s $TEMP ]; do
        sleep 0.01
        echo waiting
    done
    # check if escape was pressed and if so exit

    key="$(cat "$TEMP")reg.temp"
    [ ${#key} = 9 ] && exit
    rm "$TEMP"
}
#get active window and save id to WIN
store () {
    WIN="$(niri msg -j focused-window | jq .id)"
    input

    echo "$WIN" > "$PAT$key"
}

load () {
    input
    # echo $key
    ID="$(cat "$PAT$key")"

    EXIST=$(niri msg -j windows | jq -c --argjson id "$ID" '[(.[].id) | contains($id)] | any')
    [ "$EXIST" = 'true' ] || exit

    # [ -s "$key" ] || exit
    cat "$PAT$key" | xargs -r niri msg action focus-window --id
}

LET=$2
case $1 in
    store)store;;
    load)load;;
    clean)rm -f "$PAT"*reg.temp;;
esac
