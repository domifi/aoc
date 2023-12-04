#!/bin/sh

input=$(< /dev/stdin)

initial_card_num=$(wc -l <<< "$input")
declare -a card_counts=( $(for i in $(seq 1 $initial_card_num); do echo 1; done) )

total_cards=1
card_id=1
while IFS=$'\n' read -r line; do
    #echo ${card_counts[*]}
    winning_expr=$(sed -E \
        -e 's/^.+: +(.+) \|.*$/\1/' \
        -e 's/ +/|/g' <<< $line
    )
    matches=$(sed -E \
        -e 's/^.*\| (.*)/\1/' \
        -e 's/ +/\n/g' <<< $line \
        | grep -Exc "$winning_expr"
    )
    if [[ "$matches" -gt 0  ]]; then
        for i in $(seq 1 $matches); do
            ((card_counts[card_id+i-1] += card_counts[card_id-1] ))
        done
    fi
    (( card_id += 1 ))
    #echo total $total_cards
    (( total_cards += card_counts[card_id-1] ))
done <<< "$input"

#echo ${card_counts[*]}
echo $total_cards
