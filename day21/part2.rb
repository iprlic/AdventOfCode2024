#!/usr/bin/env ruby
# frozen_string_literal: true
require 'json'

#+---+---+---+
#| 7 | 8 | 9 |
#+---+---+---+
#| 4 | 5 | 6 |
#+---+---+---+
#| 1 | 2 | 3 |
#+---+---+---+
#    | 0 | A |
#    +---+---+
$memo_keypad = {
    'A': {'A': 'A', '0': '<A', '1': '^<<A', '2': '<^A', '3': '^A', '4': '^^<<A', '5': '<^^A', '6': '^^A', '7': '^^^<<A', '8': '<^^^A', '9': '^^^A'},
    '0': {'A': '>A', '0': 'A', '1': '^<A', '2': '^A', '3': '^>A', '4': '^^<A', '5': '^^A', '6': '^^>A', '7': '^^^<A', '8': '^^^A', '9': '^^^>A'},
    '1': {'A': '>>vA', '0': '>vA', '1': 'A', '2': '>A', '3': '>>A', '4': '^A', '5': '^>A', '6': '^>>A', '7': '^^A', '8': '^^>A', '9': '^^>>A'},
    '2': {'A': 'v>A', '0': 'vA', '1': '<A', '2': 'A', '3': '>A', '4': '<^A', '5': '^A', '6': '^>A', '7': '<^^A', '8': '^^A', '9': '^^>A'},
    '3': {'A': 'vA', '0': '<vA', '1': '<<A', '2': '<A', '3': 'A', '4': '<<^A', '5': '<^A', '6': '^A', '7': '<<^^A', '8': '<^^A', '9': '^^A'},
    '4': {'A': '>>vvA', '0': '>vvA', '1': 'vA', '2': 'v>A', '3': 'v>>A', '4': 'A', '5': '>A', '6': '>>A', '7': '^A', '8': '^>A', '9': '^>>A'},
    '5': {'A': 'vv>A', '0': 'vvA', '1': '<vA', '2': 'vA', '3': 'v>A', '4': '<A', '5': 'A', '6': '>A', '7': '<^A', '8': '^A', '9': '^>A'},
    '6': {'A': 'vvA', '0': '<vvA', '1': '<<vA', '2': '<vA', '3': 'vA', '4': '<<A', '5': '<A', '6': 'A', '7': '<<^A', '8': '<^A', '9': '^A'},
    '7': {'A': '>>vvvA', '0': '>vvvA', '1': 'vvA', '2': 'vv>A', '3': 'vv>>A', '4': 'vA', '5': 'v>A', '6': 'v>>A', '7': 'A', '8': '>A', '9': '>>A'},
    '8': {'A': 'vvv>A', '0': 'vvvA', '1': '<vvA', '2': 'vvA', '3': 'vv>A', '4': '<vA', '5': 'vA', '6': 'v>A', '7': '<A', '8': 'A', '9': '>A'},
    '9': {'A': 'vvvA', '0': '<vvvA', '1': '<<vvA', '2': '<vvA', '3': 'vvA', '4': '<<vA', '5': '<vA', '6': 'vA', '7': '<<A', '8': '<A', '9': 'A'}
}
def keypad_move(char, goal)
   return $memo_keypad[char.to_sym][goal.to_sym]
end

#    +---+---+
#    | ^ | A |
#+---+---+---+
#| < | v | > |
#+---+---+---+
#$memo_robot = {
#        'A'.chars => {'A'.chars => 'A'.chars, '<'.chars => 'v<<A'.chars, '^'.chars => '<A'.chars, '>'.chars => 'vA'.chars, 'v'.chars => '<vA'.chars},
#        '<'.chars => {'A'.chars => '>>^A'.chars, '<'.chars => 'A'.chars, '^'.chars => '>^A'.chars, '>'.chars => '>>A'.chars, 'v'.chars => '>A'.chars},
#        '^'.chars => {'A'.chars => '>A'.chars, '<'.chars => 'v<A'.chars, '^'.chars => 'A'.chars, '>'.chars => 'v>A'.chars, 'v'.chars => 'vA'.chars},
#        '>'.chars => {'A'.chars => '^A'.chars, '<'.chars => '<<A'.chars, '^'.chars => '<^A'.chars, '>'.chars => 'A'.chars, 'v'.chars => '<A'.chars},
#        'v'.chars => {'A'.chars => '^>A'.chars, '<'.chars => '<A'.chars, '^'.chars => '^A'.chars, '>'.chars => '>A'.chars, 'v'.chars => 'A'.chars}
#}

#<v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A

$memo_robot = {
        'A' => {'A' => 'A', '<' => 'v<<A', '^' => '<A', '>' => 'vA', 'v' => '<vA'},
        '<' => {'A' => '>>^A', '<' => 'A', '^' => '>^A', '>' => '>>A', 'v' => '>A'},
        '^' => {'A' => '>A', '<' => 'v<A', '^' => 'A', '>' => 'v>A', 'v' => 'vA'},
        '>' => {'A' => '^A', '<' => '<<A', '^' => '<^A', '>' => 'A', 'v' => '<A'},
        'v' => {'A' => '^>A', '<' => '<A', '^' => '^A', '>' => '>A', 'v' => 'A'}
}

def robot_move(char, goal)
    return $memo_robot[char][goal]
end

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path).split("\n").map { |line| line.chars }

codes_numeric = input.map { |line| line.take(3).join.to_i }

robots_cnt = 25
codes_cnt = input.size

sum = 0
input.each_with_index do |line, l|

    current_line = line
  
    2.times do |i|
        new_line = []
        prev_char = "A"
        (0..current_line.size-1).each do |j|
            char = current_line[j]
            if i == 0
                new_line.push(*keypad_move(prev_char, char).chars)
            else
                new_line.push(*robot_move(prev_char, char))
            end
            prev_char = char 
        end

        current_line = new_line
    end

    current_tally = current_line.tally


    (robots_cnt).times.each do |i|
        new_tally = {}

        current_tally.each do |key, value|
            chars = key.chars
            
            prev_char = "A"
            chars.each_with_index do |char, j|
                new_move = robot_move(prev_char, char)
                new_tally[new_move] = 0 if new_tally[new_move].nil?
                new_tally[new_move] += value
                prev_char = char
            end
        end

        
        current_tally = new_tally
    end

    sum += current_tally.values.sum * codes_numeric[l]
end