package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "utils"

range_touple :: struct {
	left:  int,
	right: int,
}

merge :: proc(ranges: ^[dynamic]range_touple, start_index: int) -> int {
	last_index := -1
	for index in start_index ..< len(ranges) {
		if !(ranges[start_index].left <= ranges[index].left &&
			   ranges[start_index].right >= ranges[index].left) {
			break
		}

		if ranges[index].right >= ranges[start_index].right {
			ranges[start_index].right = ranges[index].right
			last_index = index
		} else {
			last_index = index
		}
	}

	return last_index
}

main :: proc() {
	content := utils.read_dataset()
	splitted := strings.split(content, "\n")

	ranges_raw := make([dynamic]string)

	for entry in splitted {
		if entry == "" {
			break
		}

		append(&ranges_raw, entry)
	}

	ranges := make([dynamic]range_touple)

	for range in ranges_raw {
		splitted := strings.split(range, "-")
		left := strconv.atoi(splitted[0])
		right := strconv.atoi(splitted[1])
		append(&ranges, range_touple{left, right})
	}

	cmp :: proc(a, b: range_touple) -> slice.Ordering {return(
			a.left < b.left ? slice.Ordering.Less : slice.Ordering.Greater \
		)}

	slice.sort_by_cmp(ranges[:], cmp)


	index := 0
	for true {
		if (index >= len(ranges) - 1) {break}

		if (ranges[index].left <= ranges[index + 1].left &&
			   ranges[index].right >= ranges[index + 1].left) {
			last_merged_index := merge(&ranges, index)
			if last_merged_index == -1 {index += 1; continue}
			remove_range(&ranges, index + 1, last_merged_index + 1)
			index -= last_merged_index - index
		}

		index += 1
	}


	out := 0

	for range in ranges {
		out += range.right - range.left + 1
	}

	fmt.println(out)
}
