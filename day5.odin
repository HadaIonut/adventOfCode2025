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

main :: proc() {
	content := utils.read_dataset()
	splitted := strings.split(content, "\n")

	ranges_raw := make([dynamic]string)
	testIds := make([dynamic]int)

	reachedEmpty := false

	for entry in splitted {
		if reachedEmpty {
			if entry == "" {continue}
			append(&testIds, strconv.atoi(entry))
		} else {
			if entry == "" {
				reachedEmpty = true
				continue
			}

			append(&ranges_raw, entry)
		}
	}

	ranges := make([dynamic]range_touple)

	for range in ranges_raw {
		splitted := strings.split(range, "-")
		left := strconv.atoi(splitted[0])
		right := strconv.atoi(splitted[1])
		append(&ranges, range_touple{left, right})
	}

	cmp :: proc(a, b: range_touple) -> slice.Ordering {return(
			a.right > b.right ? slice.Ordering.Less : slice.Ordering.Greater \
		)}

	slice.sort_by_cmp(ranges[:], cmp)

	out := 0


	for id in testIds {
		for range in ranges {
			if id >= range.left && id <= range.right {out += 1; break}
			if id > range.right {break}
		}
	}

	fmt.println(out)

}
