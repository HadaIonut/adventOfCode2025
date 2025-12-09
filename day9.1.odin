package main

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import "utils"

main :: proc() {
	content := utils.read_dataset()
	lines := strings.split(content, "\n")
	out := "polygon("
	for line in lines {
		out = strings.concatenate([]string{out, "(", line, ")", ","})
	}

	fmt.println(out)

}
