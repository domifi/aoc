package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type mask struct {
	or  uint64
	and uint64
}
type line struct {
	isMem bool // true for mem, false for mask
	// mem:
	adr uint64 // memory adress
	val uint64 // value to write
	// mask:
	mask mask
}
type program struct {
	currentMask mask
	code        []line
	memory      map[uint64]uint64
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func readCode(r io.Reader) (program, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	var program program
	program.memory = make(map[uint64]uint64)
	exprMem := regexp.MustCompile(`^mem\[\d+\] = \d+$`)
	exprMask := regexp.MustCompile(`^mask = [X01]{36}$`)
	for scanner.Scan() {
		var l line
		var err error
		text := scanner.Text()
		if exprMem.MatchString(text) {
			l.isMem = true
			tmp := strings.Split(strings.Split(text, "[")[1], "]")
			l.adr, err = strconv.ParseUint(tmp[0], 10, 36)
			if err != nil {
				return program, err
			}
			l.val, err = strconv.ParseUint(tmp[1][3:], 10, 36)
			if err != nil {
				return program, err
			}
		} else if exprMask.MatchString(text) {
			l.isMem = false
			tmp := text[7:]
			l.mask.and, err = strconv.ParseUint(strings.ReplaceAll(tmp, "X", "1"), 2, 36)
			if err != nil {
				return program, err
			}
			l.mask.or, err = strconv.ParseUint(strings.ReplaceAll(tmp, "X", "0"), 2, 36)
			if err != nil {
				return program, err
			}
		} else {
			return program, fmt.Errorf("malformed code line: %s", text)
		}
		program.code = append(program.code, l)
	}
	return program, scanner.Err()
}

func applyMask(v uint64, m mask) uint64 {
	return (v & m.and) | m.or
}

func (p *program) step() {
	l := p.code[0]
	if l.isMem {
		p.memory[l.adr] = applyMask(l.val, p.currentMask)
	} else {
		p.currentMask = l.mask
	}
	p.code = p.code[1:]
}

func (p *program) play() uint64 {
	for len(p.code) > 0 {
		p.step()
	}
	var sum uint64
	for _, v := range p.memory {
		sum += v
	}
	return sum
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readCode(file)
	check(err)
	defer file.Close()

	fmt.Println(m.play())
}
