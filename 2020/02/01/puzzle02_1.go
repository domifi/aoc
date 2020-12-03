package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

type password struct {
	min, max int
	c        byte
	word     string
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// reads a single password of following format into the right struct: "1-3 a: abcde"
func readPassword(s string) (password, error) {
	var ret password
	emptyPassword := password{0, 0, '\x00', ""}

	// find minimum and save it:
	slice := strings.Split(s, "-")
	if len(slice) != 2 {
		return emptyPassword, fmt.Errorf("Couldn't parse min of String: %s", s)
	}
	var err error
	ret.min, err = strconv.Atoi(slice[0])
	if err != nil {
		return emptyPassword, err
	}

	// find maximum and save it:
	slice = strings.Fields(slice[1])
	if len(slice) != 3 {
		return emptyPassword, fmt.Errorf("Couldn't parse max of String: %s", s)
	}
	ret.max, err = strconv.Atoi(slice[0])
	if err != nil {
		return emptyPassword, err
	}

	// find character and save it:
	ret.c = slice[1][0]

	// find the actual password and save it:
	ret.word = slice[2]

	return ret, nil
}

func readPasswords(r io.Reader) ([]password, error) {
	scanner := bufio.NewScanner(r)
	scanner.Split(bufio.ScanLines)
	var result []password
	for scanner.Scan() {
		x, err := readPassword(scanner.Text())
		check(err)

		result = append(result, x)
	}

	return result, scanner.Err()
}

func checkPassword(p password) bool {
	count := strings.Count(p.word, string([]byte{p.c}))
	return count >= p.min && count <= p.max
}

func countBadPWs(passwords []password) int {
	sum := 0
	for _, v := range passwords {
		if checkPassword(v) {
			sum++
		}
	}
	return sum
}

func main() {
	file, err := os.Open("../input")
	check(err)
	passwords, err := readPasswords(file)
	check(err)
	defer file.Close()

	fmt.Println(countBadPWs(passwords))
}
