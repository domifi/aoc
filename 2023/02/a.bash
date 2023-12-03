#!/bin/bash

sum=0
declare -A maximum
maximum=(red 12 green 13 blue 14)

while IFS=$'\n' read -r line; do
    game_num=$(echo $line | sed -E 's/^Game ([0-9]+):.*/\1/')
    valid_game=true

    for i in $(echo $line | sed -E \
        -e 's/Game [0-9]+: //' \
        -e 's/[,;]//g' \
        -e 's/([0-9]+) ([a-z]+)/\2:\1/g'
    )
    do
        key=$(echo $i | sed -E 's/([^:]):.*/\1/')
        value=$(echo $i | sed -E 's/[^:]+:(.*)/\1/')
        if [[ $value -gt ${maximum["$key"]} ]]
        then
            valid_game=false
        fi
    done;

    if [ "$valid_game" = true ]
    then
        ((sum += game_num))
    fi
done

echo $sum
