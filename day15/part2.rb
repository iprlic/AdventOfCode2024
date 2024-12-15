#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
grid, moves = File.read(file_path).split("\n\n")

moves = moves.gsub("\n", "").chars

grid = grid.split("\n").map { |row| row.chars }

grid = grid.map do |row|
    row.map do |tile|
      case tile
      when '#'
        '##'
      when 'O'
        '[]'
      when '.'
        '..'
      when '@'
        '@.'
      end
    end
  end.map{ |row| row.map(&:chars).flatten }



robot = {}
grid.each_with_index do |row, y|
    breakout = false
    row.each_with_index do |cell, x|
        if cell == '@'
            robot = { x: y, y: x } 
            breakout = true
            break
        end
    end
    break if breakout
end


dirs= { 'v' => [1, 0], '^' => [-1, 0], '<' => [0, -1], '>' => [0, 1] }

moves.each_with_index do |move, i|
    dx, dy = dirs[move]

    next_x = robot[:x] + dx
    next_y = robot[:y] + dy
    
    if grid[next_x][next_y] == '.'
        grid[robot[:x]][robot[:y]] = '.'
        robot[:x] = next_x
        robot[:y] = next_y
        grid[robot[:x]][robot[:y]] = '@'
    elsif grid[next_x][next_y] == '[' || grid[next_x][next_y] == ']'

        if move == '<' || move == '>'
            current_x, current_y = next_x, next_y
            boxes_to_move = []

            while grid[current_x][current_y] == '[' || grid[current_x][current_y] == ']'
                boxes_to_move << [current_x, current_y, grid[current_x][current_y]]
                current_x += dx
                current_y += dy
            end
        
            if grid[current_x][current_y] == '.'
                
                grid[robot[:x]][robot[:y]] = '.'
                robot[:x] = next_x
                robot[:y] = next_y
                grid[robot[:x]][robot[:y]] = '@'

                boxes_to_move.each do |box|
                    grid[box[0] + dx][box[1] + dy] = box[2]
                end
            end
        else
            current = [{x: next_x, y:next_y, box: grid[next_x][next_y]}]
            if current.first[:box] == '['
                current.push({x: next_x, y: next_y + 1, box: grid[next_x][next_y + 1]})
            else
                current.push({x: next_x, y: next_y - 1, box: grid[next_x][next_y - 1]})
            end
            
            current.sort_by! { |c| c[:y] }
            boxes_to_move = []  
            boxes_to_move.push(current)
            can_move = false

            loop do
                current = current.map do |c|
                    { x: c[:x] + dx, y: c[:y], box: grid[c[:x] + dx][c[:y]] }
                end

                if current.all? { |c| c[:box] == '.' }
                    can_move = true
                    break
                end

                if current.all? { |c| c[:box] == '[' || c[:box] == ']' || c[:box] == '.' }
                    current = current.select { |c| c[:box] == '[' || c[:box] == ']' }
                    current.unshift({x: current.first[:x], y:current.first[:y]-1, box:'['}) if current.first[:box] == ']'
                    current.push({x: current.last[:x], y:current.last[:y]+1, box:']'}) if current.last[:box] == '['
                    
                    boxes_to_move.push(current)
                else
                    break
                end
            end

            if can_move
                grid[robot[:x]][robot[:y]] = '.'
                
                boxes_to_move.each do |boxes|
                    boxes.each do |box|
                        grid[box[:x]][box[:y]] = '.'
                    end
                end
                

                boxes_to_move.each do |boxes|
                    boxes.each do |box|
                        grid[box[:x] + dx][box[:y]] = box[:box]
                    end
                end

                robot[:x] = next_x
                robot[:y] = next_y
                grid[robot[:x]][robot[:y]] = '@'
            end
            
        end
    end

end

sum = 0
grid.each_with_index do |row, y|

    row.each_with_index do |cell, x|
        sum += (x + y*100) if cell == '['
    end
end

puts sum