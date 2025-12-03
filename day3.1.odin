package main

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import "utils"

main :: proc() {
	content := utils.read_dataset()

	out := 0

	for line in strings.split_lines_iterator(&content) {
		bank := strings.split(line, "")
		stack := make([dynamic]int)

		for battery, index in bank {
			joltage := strconv.atoi(battery)

			for (len(stack) > 0) &&
			    (stack[len(stack) - 1] < joltage) &&
			    (len(bank) - index + len(stack) > 12) {
				pop(&stack)
			}


			if len(stack) < 12 {
				append(&stack, joltage)
			}
		}

		line_res_string := make([]string, 12)

		for val, index in stack {
			line_res_string[index] = fmt.tprintf("%v", val)
		}
		res := strings.join(line_res_string, "")
		line_res := strconv.atoi(res)
		out += line_res
	}
	fmt.println(out)
}
