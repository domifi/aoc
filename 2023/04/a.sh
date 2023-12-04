#!/bin/sh

total_points=0

while IFS=$'\n' read -r line; do
    winning_expr=$(sed -E \
        -e 's/^.+: +(.+) \|.*$/\1/' \
        -e 's/ +/|/g' <<< $line
    )
    nums=$(sed -E \
        -e 's/^.*\| (.*)/\1/' \
        -e 's/ +/\n/g' <<< $line \
        | grep -Exc "$winning_expr"
    )

    if [[ "$nums" -gt 0 ]]
    then
        (( total_points += 2**(nums-1) ))
    fi
done

echo $total_points
