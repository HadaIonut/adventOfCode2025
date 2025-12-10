package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import rg "core:text/regex"
import "utils"

machine :: struct {
	lights:  []bool,
	buttons: [][]int,
	joltage: []int,
}

parse_input :: proc(lines: []string, data: ^[]machine) {

	regex, err := rg.create("\\[([.#]+)\\] (.*) \\{([0-9,]+)\\}")
	for line, line_index in lines {
		res, succ := rg.match(regex, line)
		if !succ {
			break
		}
		usefull := res.groups[1:]
		button_groups := strings.split(usefull[1], " ")
		joltage_split := strings.split(usefull[2], ",")
		data[line_index].lights = make([]bool, len(usefull[0]))
		data[line_index].buttons = make([][]int, len(button_groups))
		data[line_index].joltage = make([]int, len(joltage_split))

		for light, index in usefull[0] {
			if light == '.' {
				data[line_index].lights[index] = false
			} else if light == '#' {
				data[line_index].lights[index] = true
			}
		}

		for entry, index in joltage_split {
			data[line_index].joltage[index] = strconv.atoi(entry)
		}

		for button, button_index in button_groups {
			trimmed := strings.trim(button, "()")
			splitted := strings.split(trimmed, ",")

			data[line_index].buttons[button_index] = make([]int, len(splitted))

			for num, index in splitted {
				data[line_index].buttons[button_index][index] = strconv.atoi(num)
			}
		}
	}
}

min_for_machine :: proc(test_machine: machine) -> int {
	min_combinations := 1
	for {
		combinations := utils.combinations(test_machine.buttons, min_combinations)

		for button_combs in combinations {
			simulated := make([]bool, len(test_machine.lights))

			for button in button_combs {
				for affected in button {
					simulated[affected] = !simulated[affected]
				}
			}

			if slice.equal(simulated, test_machine.lights) {
				return min_combinations
			}
		}

		min_combinations += 1
	}
}


main :: proc() {
	content := utils.read_dataset()
	lines := strings.split(content, "\n")
	data := make([]machine, len(lines) - 1)

	parse_input(lines, &data)

	out := 0
	for machine, index in data {
		out += min_for_machine(machine)
	}

	fmt.println(out)
}
