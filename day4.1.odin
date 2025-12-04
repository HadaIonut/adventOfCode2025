package main

import "core:fmt"
import "core:strings"
import "utils"

main :: proc() {
	content := utils.read_dataset_as_matrix()
	directions := [][]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}, {1, 1}, {-1, 1}, {1, -1}, {-1, -1}}

	out := 0

	for (true) {
		for row, row_index in content {
			for cell, cell_index in row {
				if cell != "@" {continue}

				neighbors := 0
				for direction in directions {
					x, y := direction[0], direction[1]

					if row_index + x >= 0 &&
					   row_index + x < len(content) &&
					   cell_index + y >= 0 &&
					   cell_index + y < len(content) {
						if (content[row_index + x][cell_index + y] == "@" ||
							   content[row_index + x][cell_index + y] == "x") {
							neighbors += 1
						}
					}
				}


				if neighbors < 4 {
					content[row_index][cell_index] = "x"
				}

			}
		}

		changed := 0

		for row, row_index in content {
			for cell, cell_index in row {
				if content[row_index][cell_index] == "x" {
					content[row_index][cell_index] = "."
					changed += 1
				}
			}
		}

		out += changed

		if (changed == 0) {
			break
		}
	}

	fmt.println(out)
}
