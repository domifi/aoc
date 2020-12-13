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
	return ret, scanner.Err()
}

func (a adapters) differences() (one, two, three int, err error) {
	one, two, three = 0, 0, 0
	a = append(a, 0)
	sort.Ints(a)
	a = append(a, a[len(a)-1]+3)

	for i, j := 0, 1; j < len(a); i, j = j, j+1 {
		switch a[j] - a[i] {
		case 1:
			one++
		case 2:
			two++
		case 3:
			three++
		default:
			return one, two, three, fmt.Errorf("found invalid jolt difference: %d", a[j]-a[i])
		}
	}

	return one, two, three, nil
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readAdapters(file)
	check(err)
	defer file.Close()

	one, _, three, err := m.differences()
	check(err)
	fmt.Println(one * three)
}
