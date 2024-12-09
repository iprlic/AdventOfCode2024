#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

#input = "2333133121414131402"

files = {}
empty = {}

reverse_empty = {}
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
        empty[loc] = {size: size, loc: [loc, loc + size -1]}
        reverse_empty[loc + size - 1] = {size: size, loc: [loc, loc + size -1]}
        Array(loc..(loc + size - 1)).each do |l|
            disk[l] = -1
        end

        file = true
    end

    loc += size
    i += 1
end


defragmented = false

files.to_a.reverse.to_h.each do |key, value|
    empty = empty.sort.to_h
    e = empty.select {|k, v| v[:size] >= value[:size] && k < value[:loc][0]}.sort.first
    next if e.nil?

    # write the file
    i = e[0]
    value[:size].times do 
        disk[i] = key
        i += 1
    end
    
    # remove the empty space
    empty.delete(e[0])
    reverse_empty.delete(e[0] + value[:size] - 1)

    # empty disk space
    value[:loc][1].downto(value[:loc][0]) do |l|
        disk[l] = -1
    end

    if e[1][:size] > value[:size]
        empty[e[0] + value[:size]] = {size: e[1][:size] - value[:size], loc: [e[0] + value[:size], e[1][:loc][1]]}
        reverse_empty[e[1][:loc][1]] = {size: e[1][:size] - value[:size], loc: [e[1][:loc][1],e[0] + value[:size]]}
    end

    new_key = value[:loc][0]
    new_size = value[:size]
    l1 = value[:loc][0]
    l2 = value[:loc][1]

    if !empty[l2+1].nil?
        ek = l2+1
        el1 = empty[l2+1][:loc][0]  
        el2 = empty[l2+1][:loc][1]
        es = empty[l2+1][:size]

        l2 = el2
        new_size += es
        empty.delete(ek)
        reverse_empty.delete(el2)
    end

    if !reverse_empty[l1-1].nil?
        ek = l1-1
        el1 = reverse_empty[l1-1][:loc][0]  
        el2 = reverse_empty[l1-1][:loc][1]
        es = reverse_empty[l1-1][:size]

        l1 = el1
        new_size += es
        new_key = l1
        empty.delete(el1)
        reverse_empty.delete(ek)
    end

    empty[new_key] = {size: new_size, loc: [l1, l2]}
    reverse_empty[l2] = {size: new_size, loc: [l1, l2]}
   
end

puts disk.reduce(0) {|acc, (k, v)| acc + ((v==-1?0:v) * k)}