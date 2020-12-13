package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"reflect"
	"strings"
)

const (
	floor = '.'
	free  = 'L'
	occu  = '#'
)

// row major order: [y][x]
type room [][]rune

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// very important Stringer
func (r room) String() string {
	var ret []string
	for _, v := range r {
		ret = append(ret, string(v))
	}
	tmp := strings.Join(ret, "\n")
	return tmp
}

func readRoom(r io.Reader) (room, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	var ret room
	for scanner.Scan() {
		ret = append(ret, []rune(scanner.Text()))
	}
	return ret, scanner.Err()
}

func (r *room) getField(x, y int) rune {
	if y >= len(*r) || x >= len((*r)[0]) || x < 0 || y < 0 {
		return free
	}
	return (*r)[y][x]
}

// returns a slice of adjacent seats
func (r *room) adjacent(x, y int) (ret []rune) {
	// 0: top
	ret = append(ret, r.adjacentRel(x, y, 0, -1))
	// 1: top-right
	ret = append(ret, r.adjacentRel(x, y, 1, -1))
	// 2: right
	ret = append(ret, r.adjacentRel(x, y, 1, 0))
	// 3: bottom-right
	ret = append(ret, r.adjacentRel(x, y, 1, 1))
	// 4: bottom
	ret = append(ret, r.adjacentRel(x, y, 0, 1))
	// 5: bottom-left
	ret = append(ret, r.adjacentRel(x, y, -1, 1))
	// 6: left
	ret = append(ret, r.adjacentRel(x, y, -1, 0))
	// 7: top-left
	ret = append(ret, r.adjacentRel(x, y, -1, -1))

	return ret
}

func (r *room) adjacentRel(x, y, dx, dy int) (ret rune) {
	field := r.getField(x+dx, y+dy)
	if field != floor {
		return field
	}
	return r.adjacentRel(x+dx, y+dy, dx, dy)
}

func (r *room) execRule(x, y int) rune {
	switch (*r)[y][x] {
	case free:
		for _, v := range r.adjacent(x, y) {
			if v == occu {
				return free
			}
		}
		return occu
	case occu:
		counter := 0
		for _, v := range r.adjacent(x, y) {
			if v == occu {
				counter++
			}
			if counter >= 5 {
				return free
			}
		}
		return occu
	case floor:
		// do nothing
	}
	return (*r)[y][x]
}

func (r *room) copy() (ret room) {
	ret = make(room, len(*r))
	for i, v := range *r {
		ret[i] = append(ret[i], v...)
	}
	return ret
}

func (r *room) step() {
	//fmt.Println(r)
	//fmt.Println()
	tmp := r.copy()
	for y, line := range *r {
		for x := range line {
			tmp[y][x] = r.execRule(x, y)
		}
	}
	*r = tmp
}

func (r *room) play() {
	prev := *r
	r.step()
	for !reflect.DeepEqual(prev, *r) {
		prev = *r
		r.step()
	}
}

func (r *room) countOccu() (sum int) {
	for _, v := range r.String() {
		if v == occu {
			sum++
		}
	}
	return sum
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readRoom(file)
	check(err)
	defer file.Close()

	m.play()
	fmt.Println(m.countOccu())
}
