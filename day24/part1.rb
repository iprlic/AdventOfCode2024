#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n")

inputs = input[0].split("\n").map do |line| 
    l = line.split(': ') 
    [l[0], l[1].to_i]
end.to_h

gates = input[1].split("\n").map do |line|
    l = line.scan(/(\w+) (\w+) (\w+) -> (\w+)/).flatten

    {
        gate1: l[0],
        gate2: l[2],
        operation: l[1],
        output: l[3]
    }
end


while gates.size > 0 do
    gates.each_with_index do |gate, index|
        if inputs.has_key?(gate[:gate1]) && inputs.has_key?(gate[:gate2])
            if gate[:operation] == 'AND'
                inputs[gate[:output]] = inputs[gate[:gate1]] & inputs[gate[:gate2]]
                gates.delete_at(index)
            elsif gate[:operation] == 'OR'
                inputs[gate[:output]] = inputs[gate[:gate1]] | inputs[gate[:gate2]]
                gates.delete_at(index)
            else
                inputs[gate[:output]] = inputs[gate[:gate1]] ^ inputs[gate[:gate2]]
                gates.delete_at(index)
            end
        end
    end
end

puts inputs.select { |k, v| k[0] == 'z' }.sort.reverse.map { |k, v| v.to_s }.join.to_i(2).to_s(10)

