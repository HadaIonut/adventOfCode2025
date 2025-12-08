package main

import "base:runtime"
import "core:fmt"
import "core:math"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:time"
import "utils"

point :: struct {
	x, y, z: int,
}

edge :: struct {
	dist:          f32,
	points:        []point,
	point_indexes: []int,
}

distance :: proc(a, b: point) -> f32 {
	return math.sqrt(
		math.pow(f32(a.x - b.x), f32(2)) +
		math.pow(f32(a.y - b.y), f32(2)) +
		math.pow(f32(a.z - b.z), f32(2)),
	)
}

non_zero_min :: proc(list: []f32) -> (f32, int) {
	min := list[0] == 0 ? list[1] : list[0]
	min_index := list[0] == 0 ? 1 : 0
	for entry, index in list {
		if entry == 0 {continue}
		if entry < min {
			min = entry
			min_index = index
		}
	}

	return min, min_index
}

main :: proc() {
	content := utils.read_dataset()
	allowed_connections := 1000
	lines := strings.split(content, "\n")
	data := make([dynamic]point)

	for line in lines {
		if line == "" {continue}
		values := strings.split(line, ",")
		append(
			&data,
			point{strconv.atoi(values[0]), strconv.atoi(values[1]), strconv.atoi(values[2])},
		)
	}

	edges := make([dynamic]edge)

	for point_1, index_1 in data {
		for point_2, index_2 in data[index_1 + 1:] {
			new_points := make([]point, 2)
			new_points[0] = point_1
			new_points[1] = point_2
			append(
				&edges,
				edge {
					distance(point_1, point_2),
					new_points,
					[]int{index_1, index_1 + 1 + index_2},
				},
			)
		}
	}

	slice.sort_by_cmp(edges[:], proc(a, b: edge) -> slice.Ordering {
		diff := a.dist - b.dist

		if diff == 0 {
			return slice.Ordering.Equal
		} else if diff < 0 {
			return slice.Ordering.Less
		} else {
			return slice.Ordering.Greater
		}
	})

	circuit_array := make([dynamic]map[point]bool)
	unused_edges := make(map[point]bool)

	for i in data {
		unused_edges[i] = true
	}

	start_time := time.now()

	for edge, edge_index in edges {
		left, right := edge.points[0], edge.points[1]

		did_something := false
		index_did_something := -1
		work_part := -1
		needs_merging := false
		index_need_merging := -1
		for circuit, index in circuit_array {
			contains_left := circuit[left]
			contains_right := circuit[right]

			if contains_left || contains_right {
				if !contains_left && did_something {
					needs_merging = true
					index_need_merging = index
					break
				} else if !contains_left {
					circuit_array[index][left] = true
					delete_key(&unused_edges, left)
				}
				if !contains_right && did_something {
					needs_merging = true
					index_need_merging = index
					break
				} else if !contains_right {
					circuit_array[index][right] = true
					delete_key(&unused_edges, right)
				}

				index_did_something = index
				did_something = true
			}
		}

		if needs_merging {
			for entry in circuit_array[index_need_merging] {
				if !circuit_array[index_did_something][entry] {
					circuit_array[index_did_something][entry] = true
				}
			}
			unordered_remove(&circuit_array, index_need_merging)
		}

		if !did_something {
			new_circuit := make(map[point]bool)
			new_circuit[left] = true
			new_circuit[right] = true
			append(&circuit_array, new_circuit)

			delete_key(&unused_edges, left)
			delete_key(&unused_edges, right)
		}

		if len(unused_edges) == 0 {
			fmt.println(left.x * right.x)
			break
		}
	}
	elapsed := time.since(start_time)
	fmt.println("time:", elapsed)
}
