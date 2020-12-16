package main

import (
	"bufio"
	"fmt"
	"io"
	"math"
	"os"
	"strconv"
	"strings"
)

// busid, position in input
type plan map[int]int

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func readPlan(r io.Reader) (plan, int, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	scanner.Scan()
	startTime, err := strconv.Atoi(scanner.Text())
	if err != nil {
		return map[int]int{}, 0, err
	}

	ret := make(map[int]int)
	scanner.Scan()
	for i, v := range strings.Split(scanner.Text(), ",") {
		if v != "x" {
			id, err := strconv.Atoi(v)
			if err != nil {
				return map[int]int{}, 0, err
			}
			ret[id] = i
		}
	}
	return ret, startTime, scanner.Err()
}

func fuckingSaneMod(n, m int) int {
	if m == 0 {
		return 0
	}
	n %= m
	if n < 0 {
		return m + n
	}
	return n
}

func solve(p plan, startTime int) int {
	id, min := 0, math.MaxInt32
	for k := range p {
		if dt := k - fuckingSaneMod(startTime, k); dt < min {
			id, min = k, dt
		}
	}
	return id * min
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, startTime, err := readPlan(file)
	check(err)
	defer file.Close()

	fmt.Println(solve(m, startTime))
}
