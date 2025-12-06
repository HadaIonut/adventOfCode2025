package main

import "core:fmt"
import "core:strconv"
import "core:strings"
import "utils"

chunk_string :: proc(s: string, n: int) -> []string {
	chunks: [dynamic]string = {}
	length := len(s)

	for i := 0; i < length; i += n {
		end := i + n
		if end > length {
			end = length
		}
		chunk := s[i:end]

		if strings.contains(chunk, "+") {
			append(&chunks, "+")
		} else if strings.contains(chunk, "*") {
			append(&chunks, "*")
		} else {
			append(&chunks, chunk[0:3])
		}

	}

	return chunks[:]
}


main :: proc() {
	content := utils.read_dataset()

	set := make([dynamic][dynamic]string)


	lines := strings.split(content, "\n")
	for line in lines {
		cells := chunk_string(line, 4)
		clean_cells := make([dynamic]string)
		for cell in cells {
			append(&clean_cells, cell)
		}
		if len(clean_cells) > 0 {
			append(&set, clean_cells)
		}
	}

	for j in 0 ..< len(set[0]) {
		row_wip := make([dynamic][]string)
		for i in 0 ..< len(set) {
			if set[i][j] == "+" || set[i][j] == "*" {continue}
			append(&row_wip, strings.split(set[i][j], ""))
		}
		for j1 in 0 ..< len(row_wip[0]) {
			out := make([dynamic]string)
			for i1 in 0 ..< len(row_wip) {
				append(&out, row_wip[i1][j1])
			}
			set[j1][j] = strings.trim(strings.join(out[:], ""), " ")
		}
	}

	fmt.println(set)

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
				entry := set[i][j]
				entry = strings.trim(entry, " ")
				append(&problem_list, strconv.atoi(entry))
			}
		}
		out += result
	}

	fmt.println(out)
}
