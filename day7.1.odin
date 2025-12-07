package main

import "core:fmt"
import "utils"

coords :: struct {
	x: int,
	y: int,
}

go_down :: proc(content: [][]string, start: coords) -> (coords, coords, int) {
	start := start
	for content[start.x][start.y] != "^" {
		start.x += 1
		if start.x > len(content) - 1 {return start, start, 1}
	}

	left, right := start, start

	left.y -= 1
	right.y += 1

	return left, right, 0
}

content: [][]string

do_id :: proc(start: coords, memo: ^map[coords]int) -> int {
	left, right, stop := go_down(content, start)
	if stop == 1 {return 1}

	value, exists := memo[start]

	if exists {
		return value
	}

	result := do_id(left, memo) + do_id(right, memo)

	memo[start] = result

	return result
}

main :: proc() {
	content = utils.read_dataset_as_matrix()

	start_col := -1
	for val, index in content[0] {
		if val == "S" {
			start_col = index
			break
		}
	}

	start := coords{0, start_col}

	memo := make(map[coords]int)

	res := do_id(start, &memo)
	fmt.println(res)
}
