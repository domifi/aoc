package main

import (
	"bufio"
	"fmt"
	"io"
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

// ggT(a, b) = u*a + v*b
// returns a, u, v
func extendedEuclid(a, b int) (int, int, int) {
	u, v, s, t := 1, 0, 0, 1
	for b != 0 {
		q := a / b
		a, b = b, a-q*b
		u, s = s, u-q*s
		v, t = t, v-q*t
	}
	return a, u, v
}

func chineseRemainder(nn, rr []int) (int, int) {
	if len(nn) == 1 {
		return nn[0], rr[0]
	}
	k := len(nn) / 2
	m, a := chineseRemainder(nn[:k], rr[:k])
	n, b := chineseRemainder(nn[k:], rr[k:])
	_, u, _ := extendedEuclid(m, n)
	x := fuckingSaneMod((b-a)*u, n)*m + a
	return m * n, x
}

func solve(p *plan) int {
	var nn, rr []int
	for k, v := range *p {
		nn = append(nn, k)
		rr = append(rr, k-v)
	}
	_, ret := chineseRemainder(nn, rr)
	return ret
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, _, err := readPlan(file)
	check(err)
	defer file.Close()

	fmt.Println(solve(&m))
}
