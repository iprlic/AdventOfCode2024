#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

#input = "2333133121414131402"

files = {}
empty = []
disk = {}


file = true
i = 0
f_id = 0
loc = 0

input = input.chars.map(&:to_i).each do |size|
    if file
        files[f_id] = {size: size, loc: [loc, loc + size -1]}
        Array(loc..(loc + size - 1)).each do |l|
            disk[l] = f_id
        end

        file = false
        f_id += 1
    else
        Array(loc..(loc + size - 1)).each do |l|
            empty.push(l)
            disk[l] = -1
        end

        file = true
    end

    loc += size
    i += 1
end


#print disk
defragmented = false

files.to_a.reverse.to_h.each do |key, value|
    value[:loc][1].downto(value[:loc][0]) do |l|
        e = empty.shift
        if e < l
            disk[e] = key
            disk[l] = -1
        else
            defragmented = true
            break
        end   
    end
    break if defragmented

    empty = (empty + value[:loc]).sort
end

puts disk.reduce(0) {|acc, (k, v)| acc + ((v==-1?0:v) * k)}