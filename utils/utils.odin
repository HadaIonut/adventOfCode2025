package utils

import "core:fmt"
import "core:os"
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
