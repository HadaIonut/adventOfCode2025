package main

import "core:fmt"
import "core:strconv"
import "core:strings"
import "utils"

main :: proc() {
	content := utils.read_dataset()

	set := make([dynamic][dynamic]string)


	lines := strings.split(content, "\n")
	for line in lines {
		cells := strings.split(line, " ")
		clean_cells := make([dynamic]string)
		for cell in cells {
			if cell != "" {
				append(&clean_cells, cell)
			}
		}
		if len(clean_cells) > 0 {
			append(&set, clean_cells)
		}
	}


	out := 0

	for j in 0 ..< len(set[0]) {
		problem_list := make([dynamic]int)
		result := -1
		for i in 0 ..< len(set) {
			if set[i][j] == "+" {
				result = 0
				for entry in problem_list {
					result += entry
				}


			} else if set[i][j] == "*" {
				result = 1
				for entry in problem_list {
					result *= entry
				}

			} else {
				append(&problem_list, strconv.atoi(set[i][j]))
			}
		}
		out += result
	}

	fmt.println(out)
}
