package utils

import "core:fmt"
import "core:os"
import "core:strings"
read_dataset :: proc() -> string {
	data, ok := os.read_entire_file("dataset_1")
	if !ok {
		fmt.println("Error reading file")
		return ""
	}
	content := string(data)
	return content
}

read_example :: proc() -> string {
	data, ok := os.read_entire_file("example_1")
	if !ok {
		fmt.println("Error reading file")
		return ""
	}
	content := string(data)
	return content
}

read_example_as_matrix :: proc() -> [][]string {
	content := read_example()
	rows := strings.split(content, "\n")
	rows = rows[:len(rows) - 1]

	data := make([][]string, len(rows))

	for row, i in rows {
		splitted_row := strings.split(row, "")


		data[i] = splitted_row
	}

	return data
}


read_dataset_as_matrix :: proc() -> [][]string {
	content := read_dataset()
	rows := strings.split(content, "\n")
	rows = rows[:len(rows) - 1]

	data := make([][]string, len(rows))

	for row, i in rows {
		splitted_row := strings.split(row, "")

		data[i] = splitted_row
	}

	return data
}
