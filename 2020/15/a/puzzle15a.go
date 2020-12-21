package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

type game struct {
	lastSpoken int
	stepNum    int
	nums       []int
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func readInput(r io.Reader, max int) (game, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	scanner.Scan()
	str := strings.Split(scanner.Text(), ",")
	var ret game
	ret.nums = make([]int, max)
	for i, v := range str {
		num, err := strconv.Atoi(v)
		if err != nil {
			return ret, err
		}
		ret.nums[num] = i
		ret.stepNum = i
		ret.lastSpoken = num
	}
	ret.nums[ret.lastSpoken] = 0
	return ret, scanner.Err()
}

func (g *game) step() {
	var ( // a
		ind, lst, tmp1, writeInd, writeVal, say int // a
	) // a
	ind = g.stepNum    // a
	lst = g.lastSpoken // a

	tmp := g.nums[g.lastSpoken]
	tmp1 = tmp // a

	writeInd = g.lastSpoken // a
	writeVal = g.stepNum    // a
	g.nums[g.lastSpoken] = g.stepNum

	if tmp == 0 && g.lastSpoken != 0 {
		g.lastSpoken = 0
	} else {
		g.lastSpoken = g.stepNum - tmp
	}
	say = g.lastSpoken // a
	g.stepNum++
	fmt.Printf("index: %d, lastSpoken: %d, tmp: %d, write: [%d]%d, say: %d\n", ind, lst, tmp1, writeInd, writeVal, say)
}

// typos are for eternity
func (g *game) pley(max int) int {
	for g.stepNum < max-1 {
		//fmt.Println(g)
		g.step()
	}
	//fmt.Println(g)
	return g.lastSpoken
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readInput(file, 2020)
	check(err)
	defer file.Close()

	//fmt.Println(m)
	fmt.Println(m.pley(2020))
}
