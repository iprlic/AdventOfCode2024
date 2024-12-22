#!/usr/bin/env ruby
# frozen_string_literal: true

#+---+---+---+
#| 7 | 8 | 9 |
#+---+---+---+
#| 4 | 5 | 6 |
#+---+---+---+
#| 1 | 2 | 3 |
#+---+---+---+
#    | 0 | A |
#    +---+---+
def keypad_move(char, goal)
    return [{position: char, move: 'A'}] if char == goal
    num = char.to_i(16)

    moves = []

    if goal == 'A'
        if num > 1 && num < 10
            move = 'v'
            position = (num - 3).to_s
            position = 'A' if char == '3'
            position = '0' if char == '2'
            moves.push({position: position, move: move})
        end
        
        if (num % 3 != 0 || num == 0) && char != 'A'
            move = '>' 
            position = (num + 1).to_s
            position = 'A' if num == 0
            moves.push({position: position, move: move})
        end
    end

    if goal == '0'
        if char == 'A' || num % 3 == 0
            move = '<'
            position = (num - 1).to_s
            position = '0' if char == 'A'
            moves.push({position: position, move: move})
        end
        if num > 1 && num < 10
            move = 'v' 
            position = (num - 3).to_s
            position = 'A' if char == '3'
            position = '0' if char == '2'
            moves.push({position: position, move: move})
        end
        if num % 3 == 1 && char != 'A'
            move = '>'
            position = (num + 1).to_s
            moves.push({position: position, move: move})
        end
    end

    if ['1', '2', '3'].include?(goal)
        if num == 0 || char == 'A'
            move = '^'
            position = '3' if char == 'A'
            position = '2' if char == '0'
            moves.push({position: position, move: move})
        end
        if num > 3 && num < 10
            move = 'v'
            position = (num - 3).to_s
            moves.push({position: position, move: move})
        end
    end

    if ['4', '5', '6'].include?(goal)
        if char == 'A' || num < 4
            move = '^'
            position = (num + 3).to_s
            position = '3' if char == 'A'
            position = '2' if char == '0'
            moves.push({position: position, move: move})
        end
        if num > 6 && num < 10
            move = 'v'
            position = (num - 3).to_s
            moves.push({position: position, move: move})
        end
    end

    if ['7', '8', '9'].include?(goal)
        if num < 7 || char == 'A'
            move = '^'
            position = (num + 3).to_s
            position = '3' if char == 'A'
            position = '2' if char == '0'
            moves.push({position: position, move: move})
        end
    end

    if ['7', '4', '1'].include?(goal)
        if num != 0 && num != 7 && num != 4 && num != 1
            move = '<'
            position = (num -1).to_s
            position = '0' if char == 'A'
            moves.push({position: position, move: move})
        end
    end

    if ['8', '5', '2'].include?(goal)
        if (num != 0 && num % 3 == 0) || char == 'A'
            move = '<'
            position = (num - 1).to_s
            position = '0' if char == 'A'
            moves.push({position: position, move: move})
        end
        if num % 3 == 1 && num != 10
            move = '>'
            position = (num + 1).to_s
            moves.push({position: position, move: move})
        end
    end

    if ['9', '6', '3'].include?(goal)
        if num % 3 != 0 && num != 10
            move = '>'
            position = (num + 1).to_s
            position = 'A' if char == '0'
            moves.push({position: position, move: move})
        end
    end

    return moves
end

#    +---+---+
#    | ^ | A |
#+---+---+---+
#| < | v | > |
#+---+---+---+

def robot_move(char, goal)
    return [{position: char, move: 'A'}] if char == goal
     
    moves = []

    if goal == '>'
        if char == 'v'
            moves.push({position: '>', move: '>'})
        end
        if char == '<'
            moves.push({position: 'v', move: '>'})
        end
        if char == '^'
            moves.push({position: 'A', move: '>'})
            moves.push({position: 'v', move: 'v'})
        end
        if char == 'A'
            moves.push({position: '>', move: 'v'})
        end
    end

    if goal == '<'
        if char == 'v'
            moves.push({position: '<', move: '<'})
        end
        if char == '>'
            moves.push({position: 'v', move: '<'})  
        end
        if char == '^'
            moves.push({position: 'v', move: 'v'})
        end
        if char == 'A'
            moves.push({position: '>', move: 'v'})
            moves.push({position: '^', move: '<'})
        end
    end

    if goal == 'v'
        if char == '<'
            moves.push({position: 'v', move: '>'})
        end
        if char == '>'
            moves.push({position: 'v', move: '<'})
        end
        if char == '^'
            moves.push({position: 'v', move: 'v'})
        end
        if char == 'A'
            moves.push({position: '>', move: 'v'})
            moves.push({position: '^', move: '<'})
        end
    end

    if goal == '^'
        if char == '<'
            moves.push({position: 'v', move: '>'})
        end
        if char == '>'
            moves.push({position: 'v', move: '<'})
            moves.push({position: 'A', move: '^'})
        end
        if char == 'v'
            moves.push({position: '^', move: '^'})
        end
        if char == 'A'
            moves.push({position: '^', move: '<'})
        end
    end

    if goal == 'A'
        if char == '<'
            moves.push({position: 'v', move: '>'})
        end
        if char == '>'
            moves.push({position: 'A', move: '^'})
        end
        if char == '^'
            moves.push({position: 'A', move: '>'})
        end
        if char == 'v'
            moves.push({position: '^', move: '^'})
            moves.push({position: '>', move: '>'})
        end
    end

    return moves

end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map { |line| line.chars }


codes_numeric = input.map { |line| line.take(3).join.to_i }



robot1 = []
# robot 1
input.each do |line|
    current = 'A'
    candidates = [ last: current, size: 0, moves:[]]
    line.each do |char|
        moves_left = true
        
        final_candidates = []
        while moves_left
            moves_left = false
            new_candidates = []

            candidates.each do |candidate|
                last = candidate[:last]
       
                if last == char.to_s
                    candidate[:size] += 1
                    candidate[:moves].push('A')
                    final_candidates.push(candidate)
                    next
                end
                moves = keypad_move(last, char.to_s)
                moves.each do |move|
                    new_moves = candidate[:moves].dup
                    new_moves.push(move[:move])
                    new_size = candidate[:size] + 1
                    new_candidates.push({ last: move[:position], moves: new_moves, size: new_size })  
                    moves_left = true
                end
   
            end
            candidates = new_candidates
        end

        candidates = final_candidates
    end

    min_size = candidates.map { |candidate| candidate[:size] }.min
    robot1.push(candidates.select{ |candidate| candidate[:size] == min_size }.map { |candidate| candidate[:moves] })
end

#robot1.first.each { |robo| puts robo.join }

#exit
robot2 = []

robot1.each do |robot_possible|
    robot_possible_2 = []
    robot_possible.each do |robot_moves|
        current = 'A'
        candidates = [ last: current, size: 0, moves:[]]
        robot_moves.each do |char|
            moves_left = true
            
            final_candidates = []
            while moves_left
                
                moves_left = false
                new_candidates = []

                candidates.each do |candidate|
                    last = candidate[:last]
            
                    if last == char
                        candidate[:size] += 1
                        candidate[:moves].push('A')
                        final_candidates.push(candidate)
                        next
                    end
                    moves = robot_move(last, char)
                    moves.each do |move|
                        new_moves = candidate[:moves].dup
                        new_moves.push(move[:move])
                        new_size = candidate[:size] + 1
                        new_candidates.push({ last: move[:position], moves: new_moves, size: new_size })  
                        moves_left = true
                    end
        
                end
                candidates = new_candidates
       
            end

            candidates = final_candidates
            
        end

        min_size = candidates.map { |candidate| candidate[:size] }.min

        robot_possible_2.push(candidates.select{ |candidate| candidate[:size] == min_size }.map { |candidate| candidate[:moves] }) 
      
    end
    
    robot_shortest = []
    robot_possible_2.each do |robos|
       robos.each do |robo|
            robot_shortest.push(robo)
       end
    end

    min_robo = robot_shortest.map { |robo| robo.size }.min
    robot2.push(robot_shortest.select { |robo| robo.size == min_robo })
    #robot2.push(robot_possible_2)
end

sum = 0
robot2.each_with_index do |robo, i|
    sum += robo.first.nil? ? 0 : robo.first.size * codes_numeric[i]
end

puts sum    
sum = 0
# robot 3
robot3 = []

robot2.each do |robot_possible|
    robot_possible_2 = []
    robot_possible.each do |robot_moves|
        current = 'A'
        candidates = [ last: current, size: 0, moves:[]]
        robot_moves.each do |char|
            moves_left = true
            
            final_candidates = []
            while moves_left
                
                moves_left = false
                new_candidates = []

                candidates.each do |candidate|
                    last = candidate[:last]
            
                    if last == char
                        candidate[:size] += 1
                        candidate[:moves].push('A')
                        final_candidates.push(candidate)
                        next
                    end
                    moves = robot_move(last, char)
                    moves.each do |move|
                        new_moves = candidate[:moves].dup
                        new_moves.push(move[:move])
                        new_size = candidate[:size] + 1
                        new_candidates.push({ last: move[:position], moves: new_moves, size: new_size })  
                        moves_left = true
                    end
        
                end
                candidates = new_candidates
       
            end

            candidates = final_candidates
            
        end

        min_size = candidates.map { |candidate| candidate[:size] }.min

        robot_possible_2.push(candidates.select{ |candidate| candidate[:size] == min_size }.map { |candidate| candidate[:moves] }) 
      
    end
    
    robot_shortest = []
    robot_possible_2.each do |robos|
       robos.each do |robo|
            robot_shortest.push(robo)
       end
    end

    min_robo = robot_shortest.map { |robo| robo.size }.min
    robot3.push(robot_shortest.select { |robo| robo.size == min_robo })
    #robot2.push(robot_possible_2)
end

sum = 0
robot3.each_with_index do |robo, i|
    sum += robo.first.nil? ? 0 : robo.first.size * codes_numeric[i]
end

puts sum