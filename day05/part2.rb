#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

def middle(a)
    return a[a.length/2-1] + a[a.length/2] if a.size.even?
    
    a[a.length/2]
 end

rules = input.split("\n\n")[0].split("\n").map { |l| l.split("|").map(&:to_i) }
updates = input.split("\n\n")[1].split("\n").map { |l| l.split(",").map(&:to_i) }

rules_after = rules.group_by { |l| l[0] }.map { |k, v| [k, v.map { |l| l[1] }] }.to_h
rules_before = rules.group_by { |l| l[1] }.map { |k, v| [k, v.map { |l| l[0] }] }.to_h

not_in_order = []

updates.each do |update|
    in_order = true
    update.each_with_index do |u, i|
        update.each_with_index do |u2, j|
              next if i == j
              if i < j
                    in_order = false if rules_after[u] && !rules_after[u].include?(u2)
                else
                    in_order = false if rules_before[u] && !rules_before[u].include?(u2)
                end
              
              break if !in_order
        end
        break if !in_order
    end
    not_in_order << update if !in_order
end
sum = 0

not_in_order.each do |update|
    loop do
        swapped = false
        (update.size-1).times do |i|
            current = update[i]
            following  = update[i+1]

            if (rules_after[current] && !rules_after[current].include?(following)) ||
                (rules_before[following] && !rules_before[following].include?(current))
                update[i], update[i+1] = update[i+1], update[i]
                swapped = true
            end
        end
        break if not swapped
    end
    sum += middle (update)
end

puts sum