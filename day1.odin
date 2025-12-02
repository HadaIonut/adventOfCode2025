package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, ok := os.read_entire_file("dataset_1")
	if !ok {
		fmt.println("Error reading file")
		return
	}
	content := string(data)

	dialPos := 50

	out := 0

	for line in strings.split_lines_iterator(&content) {
		num := line[1:]
		value, ok := strconv.parse_int(num)
		if !ok {
			fmt.println("cannot convert string to int")
			fmt.println(num)
			return
		}

		if line[0] == 'L' {
			dialPos -= value
		} else {
			dialPos += value
		}

		for (dialPos < 0) {dialPos = 100 + dialPos}

		if dialPos >= 100 {
			dialPos = dialPos % 100
		}

		if dialPos == 0 {
			out += 1
		}
	}
	fmt.println(out)
}
