#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n")

registars = input.first.split("\n").map { |line| line.split(' ').last.to_i }
program = input.last.split(' ').last.split(',').map(&:to_i) 

a = registars[0]
b = registars[1]
c = registars[2]


skip = false
pointer = 0
output = []
len = program.size

while pointer < len-1
    skip = false

    opcode = program[pointer]
    operand = program[pointer + 1]

    combo = operand
    combo = a if operand == 4
    combo = b if operand == 5
    combo = c if operand == 6

    case opcode
    when 0
        result = a.to_f / 2**combo
        a = result.to_i
    when 1
        b = b^operand
    when 2
        b = combo % 8
    when 3
        if a != 0
            skip = true
            pointer = operand
        end
    when 4
        b = b^c
    when 5
        output.push(combo%8)
    when 6
        result = a.to_f / 2**combo
        b = result.to_i
    when 7
        result = a.to_f / 2**combo
        c = result.to_i
    end

    puts "opcode: #{opcode}, A: #{a}, B: #{b}, C: #{c}" 

    pointer += 2 unless skip
end


puts output.join(',')