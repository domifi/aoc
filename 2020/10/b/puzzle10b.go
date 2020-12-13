package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"sort"
	"strconv"
)

type adapters []int

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func readAdapters(r io.Reader) (adapters, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	var ret adapters
	for scanner.Scan() {
		i, err := strconv.Atoi(scanner.Text())
		if err != nil {
			return ret, err
		}
		ret = append(ret, i)
	}
	ret = append(ret, 0)
	sort.Ints(ret)
	ret = append(ret, ret[len(ret)-1]+3)
	return ret, scanner.Err()
}

func elem(e int, slice []int) bool {
	for _, v := range slice {
		if v == e {
			return true
		}
	}
	return false
}

func (a *adapters) combinations(joltage int, combinations *map[int]int) (sum int) {
	// is in list
	if v, ok := (*combinations)[joltage]; ok {
		return v
	} else if joltage < 0 { // is too low
		return 0
	} else if !elem(joltage, *a) { // is not adapter
		(*combinations)[joltage] = 0
		return 0
	}
	// is not yet in list
	(*combinations)[joltage] =
		a.combinations(joltage-1, combinations) +
			a.combinations(joltage-2, combinations) +
			a.combinations(joltage-3, combinations)
	return (*combinations)[joltage]
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readAdapters(file)
	check(err)
	defer file.Close()

	combMap := make(map[int]int)
	combMap[m[1]] = 1
	combMap[m[0]] = 1
	fmt.Println(m.combinations(m[len(m)-1], &combMap))
}
