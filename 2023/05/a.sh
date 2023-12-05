#!/bin/sh

input=$(< /dev/stdin)

declare -a seeds
seeds=($(head -n 1 <<< $input | sed -E 's/seeds: +//'))
declare -a mapped
clear=$(for i in $(seq 1 ${#seeds[*]}); do echo 0; done)
mapped=( $clear )
maps=$(sed -E -e '/^[^0-9].*$/ d' -e 's/^$/#/' <<< $input)

#echo start:
#echo ${seeds[*]}
#echo rest:
while IFS=$' ' read -r dest src range; do
    if [[ "$dest" == '#' ]]; then
        mapped=( $clear )
    else
        for i in ${!seeds[*]}; do
            seed=${seeds[i]}
            if [[ ${mapped[i]} -eq 0 ]] && [[ $seed -ge $src ]] && [ $seed -lt $((src+range)) ]; then
                #echo Source: $src, Destination: $dest, Range: $range
                (( seeds[i] = seed-src + dest ))
                (( mapped[i] = 1 ))
            fi
        done
    fi
    #echo ${seeds[*]}
done <<< "$maps"

grep -Eo '[0-9]+' <<< ${seeds[*]} | sort -n | head -n 1
