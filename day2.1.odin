package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

import "utils"

is_fake_2 :: proc(entry: string) -> bool {
	first := entry[0]
	list := make([]u8, 1)
	list[0] = first
	for i in 0 ..= len(entry) / 2 {
		target := i == 0 ? string(list) : entry[0:i]
		counts := strings.count(entry, target)
		if counts <= 1 {continue}

		if strings.repeat(target, counts) == entry {
			return true
		}
	}
	return false
}

main :: proc() {
	content := utils.read_dataset()

	ranges := strings.split(content, ",")

	result := 0

	for range in ranges {
		entries := strings.split(range, "-")
		left := entries[0]
		right := entries[1]

		for i in strconv.atoi(left) ..= strconv.atoi(right) {
			val := fmt.tprintf("%v", i)

			if is_fake_2(val) {
				result += i
			}
		}
	}
	fmt.println("result:", result)
}
