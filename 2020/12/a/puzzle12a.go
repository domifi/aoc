package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
)

// directions for use in actions
const (
	N = 'N'
	S = 'S'
	E = 'E'
	W = 'W'
	L = 'L'
	R = 'R'
	F = 'F'
)

type action int
type line struct {
	act   action
	value int
}
type instructions []line
type boat struct {
	facing action       // N, S, W or E
	x, y   int          // position (S=y+, E=x+)
	inst   instructions // remaining instructions
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// just read the instructions
func readInstruction(r io.Reader) (boat, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	var inst instructions
	for scanner.Scan() {
		text := scanner.Text()
		var l line
		l.act = action(text[0])
		v, err := strconv.Atoi(text[1:])
		if err != nil {
			return boat{}, err
		}
		l.value = v
		inst = append(inst, l)
	}
	ret := boat{E, 0, 0, inst}
	return ret, scanner.Err()
}

func (b *boat) step() (x, y int) {
	if len(b.inst) <= 0 {
		return b.x, b.y
	}
	inst := b.inst[0]
	b.inst = b.inst[1:]

	switch inst.act {
	case N:
		b.y += inst.value
	case S:
		b.y -= inst.value
	case E:
		b.x += inst.value
	case W:
		b.x -= inst.value
	case L:
		b.facing = deg2dir(fuckingSaneMod((dir2deg(b.facing) - inst.value), 360))
	case R:
		b.facing = deg2dir(fuckingSaneMod((dir2deg(b.facing) + inst.value), 360))
	case F:
		switch b.facing {
		case N:
			b.y += inst.value
		case S:
			b.y -= inst.value
		case E:
			b.x += inst.value
		case W:
			b.x -= inst.value
		default:
			fmt.Println("me poop")
		}
	}
	return b.x, b.y
}

func abs(n int) int {
	if n < 0 {
		return n * -1
	}
	return n
}

func manhatten(x1, y1, x2, y2 int) int {
	return abs(x1-x2) + abs(y1-y2)
}

func (b *boat) play() (x, y int) {
	for len(b.inst) > 0 {
		b.step()
		//fmt.Println(*b)
	}
	return b.x, b.y
}

func dir2deg(dir action) int {
	switch dir {
	case E:
		return 0
	case S:
		return 90
	case W:
		return 180
	case N:
		return 270
	default:
		fmt.Printf("I cannot be arsed for proper error handling dir2deg: %d\n", dir)
		return 0
	}
}

func deg2dir(deg int) action {
	deg = fuckingSaneMod(deg, 360)
	switch deg {
	case 0:
		return E
	case 90:
		return S
	case 180:
		return W
	case 270:
		return N
	default:
		fmt.Printf("I cannot be arsed for proper error handling deg2dir: %d\n", deg)
		return F
	}
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

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readInstruction(file)
	check(err)
	defer file.Close()

	x, y := m.play()
	fmt.Println(manhatten(0, 0, x, y))
}
