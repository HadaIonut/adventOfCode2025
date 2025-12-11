package main

import "core:fmt"
import "core:strings"
import "utils"


bool_to_string :: proc(entry: bool) -> string {
	if entry {
		return "true"
	} else {
		return "false"
	}
}

find_outs :: proc(
	data: map[string][]string,
	connection: string,
	seen_fft, seen_dac: bool,
	memo: ^map[string]int,
) -> int {
	res := 0
	if connection == "out" {
		return seen_fft && seen_dac ? 1 : 0
	}

	for con in data[connection] {
		val, exists :=
			memo[strings.concatenate([]string{con, bool_to_string(con == "fft" || seen_fft), bool_to_string(con == "dac" || seen_dac)})]

		if exists {
			res += val
		} else {
			out := find_outs(data, con, con == "fft" || seen_fft, con == "dac" || seen_dac, memo)
			res += out
			memo[strings.concatenate([]string{con, bool_to_string(con == "fft" || seen_fft), bool_to_string(con == "dac" || seen_dac)})] =
				out
		}
	}
	return res
}

main :: proc() {
	content := utils.read_dataset()
	data := make(map[string][]string)
	memo := make(map[string]int)

	for line in strings.split(content, "\n") {
		if line == "" {continue}
		split := strings.split(line, ": ")
		outputs := strings.split(split[1], " ")
		data[split[0]] = outputs
	}


	fmt.println(find_outs(data, "svr", false, false, &memo))

}
