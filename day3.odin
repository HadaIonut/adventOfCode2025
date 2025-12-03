package main

import "core:fmt"
import "core:strconv"
import "core:strings"
import "utils"

main :: proc() {
	content := utils.read_dataset()

	out := 0

	for line in strings.split_lines_iterator(&content) {
		bank := strings.split(line, "")
		max1 := -1
		max1_pos := -1

		for battery, index in bank {
			joltage := strconv.atoi(battery)

			if joltage > max1 {
				max1 = joltage
				max1_pos = index
			}
		}
		max2 := -1
		if (max1_pos < len(bank) - 1) {
			for index in (max1_pos + 1) ..< len(bank) {
				joltage := strconv.atoi(bank[index])

				if joltage > max2 {
					max2 = joltage
				}
			}
		} else {
			max2 = max1
			max1 = -1

			for index in 0 ..< max1_pos {
				joltage := strconv.atoi(bank[index])

				if joltage > max1 {
					max1 = joltage
				}
			}
		}
		line_joltage := max1 * 10 + max2
		out += line_joltage
	}
	fmt.println(out)
}
