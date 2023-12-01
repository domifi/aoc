#!/bin/sh

sum=0

nums=$(sed -E "s/^[^0-9]*([0-9]).*([0-9]).*$/\1\2/" <&0 \
    | sed -E "s/^[^0-9]*([0-9])[^0-9]*$/\1\1/")

for num in $nums; do
    ((sum += num))
done

echo $sum
