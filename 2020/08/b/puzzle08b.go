package main

import (
	"bufio"
	"errors"
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
	end = instruction("end")
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
	valid := regexp.MustCompile(`^(jmp|acc|nop|end) [+-][0-9]+$`)
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

	ret.addLine("end +0")
	return ret, scanner.Err()
}

// if not visited: returns value of accumulator after execution and true
// if visited: returns current state of accumulator and false
func (c *code) step() (accumulator int, ok bool, ends bool, err error) {
	l := &c.text[c.ptr]
	if l.visited {
		return c.accumulator, false, false, nil
	}

	switch l.inst {
	case acc:
		c.accumulator += l.argument
		c.ptr++
	case jmp:
		newPtr := c.ptr + l.argument
		if newPtr < 0 || newPtr > len(c.text)-1 {
			err := fmt.Errorf("jump out of bounds: jump to %d in line %d", newPtr, c.ptr)
			return c.accumulator, false, false, err
		}
		c.ptr = newPtr
	case nop:
		c.ptr++
	case end:
		return c.accumulator, true, true, nil
	}
	l.visited = true
	return c.accumulator, true, false, nil
}

func (c *code) exec() (accum int, ends bool, err error) {
	var ok bool
	for accum, ok, ends, err = c.step(); ok && !ends; accum, ok, ends, err = c.step() {
		if err != nil {
			return accum, ends, err
		}
	}
	return accum, ends, nil
}

func (c *code) reset() {
	c.ptr = 0
	c.accumulator = 0
	for i := range c.text {
		c.text[i].visited = false
	}
}

// tries to fix line i. If not appropriate tries to fix the next.
// returns which line was fixed
func (c *code) fix(i int) (int, bool) {
	if i >= len(c.text) {
		return i, true
	}

	switch c.text[i].inst {
	case jmp:
		c.text[i].inst = nop
	case nop:
		c.text[i].inst = jmp
	case acc:
		return c.fix(i + 1)
	case end:
		return c.fix(i + 1)
	}
	return i, false
}

func (c *code) findEnd() (accum int, err error) {
	for i := 0; i < len(c.text); c.reset() {
		fixed, end := c.fix(i)
		if end {
			return 0, errors.New("couldn't find terminating condition")
		}
		accum, ends, err := c.exec()
		if err != nil {
			return accum, err
		}
		if ends {
			return accum, nil
		}
		c.fix(fixed)
		i = fixed + 1
	}
	return 0, errors.New("couldn't find terminating condition")
}

func main() {
	file, err := os.Open("../input")
	check(err)
	m, err := readCode(file)
	check(err)
	defer file.Close()

	fmt.Println(m.findEnd())
}
