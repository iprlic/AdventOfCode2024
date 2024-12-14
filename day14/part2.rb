#!/usr/bin/env ruby
# frozen_string_literal: true

def display(input, maxX, maxY)
    grid = Array.new(maxY+1) { Array.new(maxX+1, '.') }

    input.each do |r|
        grid[r[:p][:y]][r[:p][:x]] = '#'
    end

    grid.each do |r|
        puts r.join('')
    end
end

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n").map{ |l| l.scan(/p=(\d*),(\d*) v=(-?\d*),(-?\d*)/).map { |a, b, c, d| {p: { x: a.to_i, y: b.to_i}, v: { x: c.to_i, y: d.to_i} } } }.flatten

maxX = 101
maxY = 103

#maxX = 11
#maxY = 7

maxX -= 1
maxY -= 1


i = 0
loop do
    i += 1
   

    input.each do |r|
        r[:p][:x] += r[:v][:x]
        
        r[:p][:x] = r[:p][:x]-maxX-1 if r[:p][:x] > maxX
        r[:p][:x] = r[:p][:x]+maxX+1 if r[:p][:x] < 0

        r[:p][:y] += r[:v][:y]

        r[:p][:y] = r[:p][:y]-maxY-1 if r[:p][:y] > maxY
        r[:p][:y] = r[:p][:y]+maxY+1 if r[:p][:y] < 0
    end


    input.group_by { |r| r[:p][:y] }.each do |k, v|
        v.each do |r|
            xs = v.map { |r| r[:p][:x] }.sort

            ls = 0
            c = 1
             
            xs.each_with_index do |x, i|
                next if i == 0
                if x == xs[i-1]+1
                    c += 1
                else
                    ls = c if c > ls
                    c = 1
                end
            end


            if c >= 10 # pure guessing
                display(input, maxX, maxY) 
        
                puts i
                exit
            end
        end
    end
      
end




