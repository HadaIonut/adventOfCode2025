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

combinations :: proc(list: []$T, n: int, allocator := context.allocator) -> [dynamic][dynamic]T {
	context.allocator = allocator
	result := make([dynamic][dynamic]T)

	if n == 0 {
		append(&result, make([dynamic]T))
		return result
	}

	if n > len(list) {
		return result
	}

	temp := make([dynamic]T)
	defer delete(temp)

	generate_combinations(&result, list, &temp, 0, n)
	return result
}

// Recursive helper function
generate_combinations :: proc(
	result: ^[dynamic][dynamic]$T,
	list: []T,
	temp: ^[dynamic]T,
	start: int,
	n: int,
) {
	if len(temp) == n {
		combo := make([dynamic]T)
		for item in temp {
			append(&combo, item)
		}
		append(result, combo)
		return
	}

	for i := start; i < len(list); i += 1 {
		append(temp, list[i])
		generate_combinations(result, list, temp, i + 1, n)
		pop(temp)
	}
}

// Generate all combinations WITH REPETITION of size n from the input list
combinations_with_repetition :: proc(
	list: []$T,
	n: int,
	allocator := context.allocator,
) -> [dynamic][dynamic]T {
	context.allocator = allocator
	result := make([dynamic][dynamic]T)

	if n == 0 {
		append(&result, make([dynamic]T))
		return result
	}

	if len(list) == 0 {
		return result
	}

	temp := make([dynamic]T)
	defer delete(temp)

	generate_combinations_with_repetition(&result, list, &temp, 0, n)
	return result
}

// Recursive helper for combinations with repetition
generate_combinations_with_repetition :: proc(
	result: ^[dynamic][dynamic]$T,
	list: []T,
	temp: ^[dynamic]T,
	start: int,
	n: int,
) {
	if len(temp) == n {
		combo := make([dynamic]T)
		for item in temp {
			append(&combo, item)
		}
		append(result, combo)
		return
	}

	// Key difference: i starts at 'start' not 'start + 1'
	// This allows the same element to be selected multiple times
	for i := start; i < len(list); i += 1 {
		append(temp, list[i])
		generate_combinations_with_repetition(result, list, temp, i, n) // Pass 'i' not 'i + 1'
		pop(temp)
	}
}
