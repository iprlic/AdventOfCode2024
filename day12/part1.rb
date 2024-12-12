#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

$mapped = {}

def can_go_up(i, j, value, grid)
    return false if i == 0
    return false if $mapped[[i-1,j]]
    return false if grid[i - 1][j] != value
    return true
end

def can_go_down(i, j, value, grid)
    return false if i == grid.length - 1
    return false if $mapped[[i+1,j]]
    return false if grid[i + 1][j] != value
    return true
end

def can_go_left(i, j, value, grid)
    return false if j == 0
    return false if $mapped[[i,j-1]]
    return false if grid[i][j - 1] != value
    return true
end

def can_go_right(i, j, value, grid)
    return false if j == grid[0].length - 1
    return false if $mapped[[i,j+1]]
    return false if grid[i][j + 1] != value
    return true
end

def get_border_cnt(i,j,cell, grid)
    sum = 0

    sum += 1 if i == 0 || grid[i-1][j] != cell
    sum += 1 if i == grid.length - 1 || grid[i+1][j] != cell
    sum += 1 if j == 0 || grid[i][j-1] != cell
    sum += 1 if j == grid[0].length - 1 || grid[i][j+1] != cell

    return sum

end



def map_area(grid, i, j, cell, new_areas = [])
    $mapped[[i,j]] = true

    cu = can_go_up(i, j, cell, grid)
    cd = can_go_down(i, j, cell, grid)
    cl = can_go_left(i, j, cell, grid)
    cr = can_go_right(i, j, cell, grid)

    border = get_border_cnt(i,j,cell,grid)

    area_data = {i: i, j: j, border: border}
    new_areas.push(area_data)

    new_areas.concat(map_area(grid, i-1, j, cell)) if cu
    new_areas.concat(map_area(grid, i+1, j, cell)) if cd
    new_areas.concat(map_area(grid, i, j+1, cell)) if cr
    new_areas.concat(map_area(grid, i, j-1, cell)) if cl


    return new_areas
end

input = File.read(file_path).split("\n").map(&:chars)


areas = []
total_price = 0

input.each_with_index do |row, a|
    row.each_with_index do |cell, b|
        next if $mapped[[a,b]]

        new_area = map_area(input, a, b, cell).uniq
        areas.push(new_area)

        total_price += new_area.size * new_area.map{|x| x[:border]}.sum

    end
end

puts total_price