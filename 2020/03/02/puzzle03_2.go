package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"
)

// line major order: [line index][row index]
type toboganMap [][]byte

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func (m toboganMap) String() string {
	ret := make([]string, len(m))
	for i, v := range m {
		ret[i] = string(v)
	}
	return strings.Join(ret, "\n")
}

func readMap(r io.Reader) (toboganMap, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	var result toboganMap
	for scanner.Scan() {
		result = append(result, []byte(scanner.Text()))
	}

	return result, scanner.Err()
}

// rides an unridden map und returns the number of crashes
func (m *toboganMap) Ride(xstep, ystep int, hits chan int) {
	sum := 0
	for x, y := 0, ystep; y <= len(*m)-ystep; y += ystep {
		x = (x + xstep) % len((*m)[y])
		if (*m)[y][x] == '#' {
			sum++
		}
	}
	hits <- sum
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readMap(file)
	check(err)
	defer file.Close()

	hits := make(chan int)
	go m.Ride(1, 1, hits)
	go m.Ride(3, 1, hits)
	go m.Ride(5, 1, hits)
	go m.Ride(7, 1, hits)
	go m.Ride(1, 2, hits)

	result := 1
	for i := 0; i < 5; i++ {
		v := <-hits
		result *= v
	}

	close(hits)
	//fmt.Print(m)
	fmt.Println(result)
}
