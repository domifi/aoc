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

type instruction string

const (
	acc = instruction("acc")
	jmp = instruction("jmp")
	nop = instruction("nop")
)

type line struct {
	inst     instruction
	argument int
	visited  bool
}

type code struct {
	accumulator int
	ptr         int
	text        []line
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func (c *code) addLine(str string) error {
	valid := regexp.MustCompile(`^(jmp|acc|nop) [+-][0-9]+$`)
	if !valid.MatchString(str) {
		return fmt.Errorf("malformed program line: '%s'", str)
	}

	var l line
	l.visited = false
	tmp := strings.SplitN(str, " ", 2)
	l.inst = instruction(tmp[0])
	var err error
	l.argument, err = strconv.Atoi(tmp[1])
	if err != nil {
		return err
	}

	c.text = append(c.text, l)
	return nil
}

func readCode(r io.Reader) (code, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	var ret code
	for scanner.Scan() {
		err := ret.addLine(scanner.Text())
		if err != nil {
			return ret, err
		}
	}

	return ret, scanner.Err()
}

// if not visited: returns value of accumulator after execution and true
// if visited: returns current state of accumulator and false
func (c *code) step() (int, bool, error) {
	l := &c.text[c.ptr]
	if l.visited {
		return c.accumulator, false, nil
	}

	switch l.inst {
	case acc:
		c.accumulator += l.argument
		c.ptr++
	case jmp:
		newPtr := c.ptr + l.argument
		if newPtr < 0 || newPtr > len(c.text)-1 {
			return c.accumulator, true, fmt.Errorf("jump out of bounds: jump to %d in line %d", newPtr, c.ptr)
		}
		c.ptr = newPtr
	case nop:
		c.ptr++
	}
	l.visited = true
	return c.accumulator, true, nil
}

func (c *code) exec() (int, error) {
	var acc int
	var ok bool
	var err error
	for acc, ok, err = c.step(); ok; acc, ok, err = c.step() {
		if err != nil {
			return acc, err
		}
	}
	return acc, nil
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readCode(file)
	check(err)
	defer file.Close()

	fmt.Println(m.exec())
}
