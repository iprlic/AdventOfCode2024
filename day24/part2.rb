#!/usr/bin/env ruby
# frozen_string_literal: true

def get_value(h,x,y,o)
    return h["#{x} #{o} #{y}"] if h.has_key?("#{x} #{o} #{y}")
    return h["#{y} #{o} #{x}"] if h.has_key?("#{y} #{o} #{x}")
    return nil
end

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n")

inputs = input[0].split("\n").map do |line| 
    l = line.split(': ') 
    [l[0], l[1].to_i]
end.to_h

gates = input[1].split("\n").map do |line|
    l = line.split(' -> ') 
    [l[0], l[1]]
end.to_h


wrong_outputs = []

prev_carry = get_value(gates, "x00", "y00", "AND")
45.times do |i|
    next if i == 0
    num = format("%02d", i)


    
    #xor_num = x_num xor y_num
    xor_num = get_value(gates, "x#{num}", "y#{num}", "XOR")
    #and_num = x_num and y_num
    and_num = get_value(gates, "x#{num}", "y#{num}", "AND")

    #and_carry = xor_num and prev_carry
    and_carry = get_value(gates, xor_num, prev_carry, "AND")
    wrong_outputs << "and_carry_#{num},#{xor_num},#{prev_carry}" if and_carry.nil?
    #z_num = xor_num xor prev_carry
    z_num = get_value(gates, xor_num, prev_carry, "XOR")
    #mjm XOR gvw -> z08
    wrong_outputs << "z_num_XOR#{num},#{xor_num},#{prev_carry}" if z_num.nil? || z_num != "z#{num}"
    #prev_carry = and_num or and_carry
    prev_carry = get_value(gates, and_num, and_carry, "OR")
    wrong_outputs << "prev_carry#{num},#{and_num},#{and_carry}" if prev_carry.nil?

    # qjb, gvw
    # jgc, z15
    # drg, z22
    # jbp, z35

    # worked out from outputs
end

puts wrong_outputs.first

puts [ "qjb", "gvw", "jgc", "z15", "drg", "z22", "jbp", "z35" ].sort.join(",")