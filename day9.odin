package main

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import "utils"

point :: struct {
	x, y: int,
}

main :: proc() {
	content := utils.read_dataset()
	lines := strings.split(content, "\n")
	data := make([dynamic]point)
	for line in lines {
		rows := strings.split(line, ",")
		if len(rows) == 1 {continue}
		append(&data, point{strconv.atoi(rows[0]), strconv.atoi(rows[1])})
	}

	max_area := -1

	for entry, index in data {
		for entry_2 in data[index + 1:] {
			if entry.x == entry_2.x || entry.y == entry_2.y {continue}
			area := (math.abs(entry_2.x - entry.x) + 1) * (math.abs(entry_2.y - entry.y) + 1)
			if area > max_area {
				max_area = area
			}
		}
	}

	fmt.println(max_area)

}
