#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
grid, moves = File.read(file_path).split("\n\n")

moves = moves.gsub("\n", "").chars

grid = grid.split("\n").map { |row| row.chars }
robot = {}
grid.each_with_index do |row, y|
    breakout = false
    row.each_with_index do |cell, x|
        if cell == '@'
            robot = { x: x, y: y } 
            breakout = true
            break
        end
    end
    break if breakout
end

dirs= { 'v' => [1, 0], '^' => [-1, 0], '<' => [0, -1], '>' => [0, 1] }
moves.each do |move|
    dx, dy = dirs[move]

    next_x = robot[:x] + dx
    next_y = robot[:y] + dy
    
    if grid[next_x][next_y] == '.'
        grid[robot[:x]][robot[:y]] = '.'
        robot[:x] = next_x
        robot[:y] = next_y
        grid[robot[:x]][robot[:y]] = '@'
    elsif grid[next_x][next_y] == 'O'
        current_x, current_y = next_x, next_y
        boxes_to_move = []

        while grid[current_x][current_y] == 'O'
            boxes_to_move << [current_x, current_y]
            current_x += dx
            current_y += dy
        end
    
        if grid[current_x][current_y] == '.'
            
            grid[robot[:x]][robot[:y]] = '.'
            robot[:x] = next_x
            robot[:y] = next_y
            grid[current_x][current_y] = 'O'
            grid[robot[:x]][robot[:y]] = '@'
        end
    end

    #puts grid.map { |row| row.join('') }.join("\n")
    #puts

end

sum = 0
grid.each_with_index do |row, y|

    row.each_with_index do |cell, x|
        sum += (x + y*100) if cell == 'O'
    end
end

puts sum