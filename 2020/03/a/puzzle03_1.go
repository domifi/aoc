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

func (m *toboganMap) CalculatePath(xstep, ystep int) error {
	if (len(*m) % ystep) != 0 {
		return fmt.Errorf("can't calculate Path for map height %d and vertical step size %d", len(*m), ystep)
	}

	for x, y := 0, ystep; y < len(*m); y += ystep {
		x = (x + xstep) % len((*m)[y])
		switch (*m)[y][x] {
		case '.': // no Tree
			(*m)[y][x] = 'O'
		case '#': // Tree
			(*m)[y][x] = 'X'
		default: // why is ther no f-ing tree?
			return fmt.Errorf("found invalid character in the toboggan map at %d:%d", x, y)
		}
	}
	return nil
}

// rides an unridden map und returns the number of crashes
func (m *toboganMap) Ride(xstep, ystep int) (int, error) {
	err := m.CalculatePath(xstep, ystep)
	if err != nil {
		return -1, err
	}

	sum := 0
	for _, v := range *m {
		sum += strings.Count(string(v), "X")
	}

	return sum, nil
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readMap(file)
	check(err)
	defer file.Close()

	sum, err := m.Ride(3, 1)
	//fmt.Print(m)
	fmt.Println(sum)
}
