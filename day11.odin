package main

import "core:fmt"
import "core:strings"
import "utils"

find_outs :: proc(data: map[string][]string, connection: string) -> int {
	res := 0
	for con in data[connection] {
		if con == "out" {res += 1}
		res += find_outs(data, con)
	}
	return res
}

main :: proc() {
	content := utils.read_dataset()
	data := make(map[string][]string)

	for line in strings.split(content, "\n") {
		if line == "" {continue}
		split := strings.split(line, ": ")
		outputs := strings.split(split[1], " ")
		data[split[0]] = outputs
	}

	start := "you"

	fmt.println(find_outs(data, start))

}
