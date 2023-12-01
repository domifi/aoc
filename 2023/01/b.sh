#!/bin/sh

sum=0

while IFS=$'\n' read -r line; do
    regexp='one|two|three|four|five|six|seven|eight|nine'
    first=$(echo $line | sed -E \
        -e "s/(${regexp})/_\1_/" \
        -e "s/_one_/1/" \
        -e "s/_two_/2/" \
        -e "s/_three_/3/" \
        -e "s/_four_/4/" \
        -e "s/_five_/5/" \
        -e "s/_six_/6/" \
        -e "s/_seven_/7/" \
        -e "s/_eight_/8/" \
        -e "s/_nine_/9/" \
        -e 's/^[^0-9]*([0-9]).*/\1/' )
    last=$(echo $line | rev | sed -E \
        -e "s/([0-9]|`echo ${regexp} | rev`)/_\1_/" \
        | rev | sed -E \
        -e "s/_one_/_1_/" \
        -e "s/_two_/_2_/" \
        -e "s/_three_/_3_/" \
        -e "s/_four_/_4_/" \
        -e "s/_five_/_5_/" \
        -e "s/_six_/_6_/" \
        -e "s/_seven_/_7_/" \
        -e "s/_eight_/_8_/" \
        -e "s/_nine_/_9_/" \
        -e 's/.*_([0-9])_.*/\1/' )
    ((sum += 10 * first + last))
done

echo $sum
