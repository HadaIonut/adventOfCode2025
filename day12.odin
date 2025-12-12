package main

import "core:fmt"
import "core:strconv"
import "core:strings"
import "utils"

shape :: struct {
	index:       int,
	shape:       string,
	used_spaces: int,
}

main :: proc() {
	content := utils.read_dataset()
	entries := strings.split(content, "\n\n")

	data := make(map[int]shape)

	for sh in entries[0:len(entries) - 1] {
		res := strings.split(sh, ":\n")
		index := strconv.atoi(res[0])
		used_spaces := strings.count(res[1], "#")

		data[index] = shape{index, res[1], used_spaces}
	}

	spaces := strings.split(entries[len(entries) - 1], "\n")

	out := 0

	for space in spaces {
		if space == "" {continue}
		zone, gifts := utils.split_once(space, ": ")

		left, right := utils.split_once(zone, "x")
		area := strconv.atoi(left) * strconv.atoi(right)

		gift_list := strings.split(gifts, " ")

		idiot_space := 0
		for gift, index in gift_list {
			if gift == "0" {continue}
			count := strconv.atoi(gift)

			idiot_space += count * data[index].used_spaces
		}
		if idiot_space < area {
			out += 1
		}
	}

	fmt.println(out)


}
