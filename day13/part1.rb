#!/usr/bin/env ruby
# frozen_string_literal: true
require 'matrix'

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n").map{ |l| l.split("\n").map{ |c| c.scan(/X(?:=|\+)(\d*), Y(?:=|\+)(\d*)/).map { |a, b| { X: a.to_i, Y: b.to_i} } }.flatten }

sum = 0
input.each do |l|
    f, s, loc = l[0], l[1], l[2]

    a1, b1, c1 = f[:X], s[:X], loc[:X]
    a2, b2, c2 = f[:Y], s[:Y], loc[:Y]

    coef = Matrix[[a1, b1], [a2, b2]]
    const = Matrix[[c1], [c2]]

    if coef.square? && coef.determinant != 0
        solution = coef.inverse * const
        x, y = solution[0, 0], solution[1, 0]

        sum += x * 3 + y if x.to_i == x && y.to_i == y
    end  
end

puts sum.to_i