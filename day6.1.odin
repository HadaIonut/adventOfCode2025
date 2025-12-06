package main

import "core:fmt"
import "core:strconv"
import "core:strings"
import "utils"

chunk_string_by_list :: proc(s: string, sizes: []int) -> []string {
	chunks := make([dynamic]string)
	idx := 0
	total := len(s)

	for size in sizes {
		if idx >= total {
			break
		}

		end := idx + size
		if end > total {
			end = total
		}

		chunk := s[idx:end]
		trimmed_chunk := strings.trim_space(chunk)

		if trimmed_chunk == "*" || trimmed_chunk == "+" {
			append(&chunks, trimmed_chunk)
		} else {
			append(&chunks, chunk)
		}

		idx = end + 1
	}

	if idx < total {
		append(&chunks, s[idx:total])
	}

	return chunks[:]
}


main :: proc() {
	content := utils.read_dataset()

	set := make([dynamic][dynamic]string)

	lines := strings.split(content, "\n")
	sign_line := lines[len(lines) - 2]

	col_lens := make([dynamic]int)

	last_pos := -1
	for char, index in sign_line {
		is_sign := char == '*' || char == '+'
		if is_sign {
			if last_pos == -1 {
				last_pos = index
			} else {
				append(&col_lens, index - last_pos - 1)
				last_pos = index
			}
		}
	}

	append(&col_lens, len(sign_line) - last_pos)

	for line in lines {
		cells := chunk_string_by_list(line, col_lens[:])
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
			set[j1][j] = strings.trim_space(strings.join(out[:], ""))
		}
	}

	for i in set {
		fmt.println(i)
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
				entry := strings.trim(set[i][j], " ")
				append(&problem_list, strconv.atoi(entry))
			}
		}
		out += result
	}

	fmt.println(out)
}
