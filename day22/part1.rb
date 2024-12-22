#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

$cache_1 = {}
def generate_secret_number(secret_number)
    return $cache_1[secret_number] if $cache_1.has_key?(secret_number)

    start = secret_number

    result = secret_number * 64
    secret_number ^= result
    secret_number %= 16777216
    
    result = secret_number / 32
    secret_number ^= result
    secret_number %= 16777216

    result = secret_number * 2048
    secret_number ^= result
    secret_number %= 16777216

    $cache_1[start] = secret_number
    
    return secret_number
end

$cache_2 = {}
def generate_nth_secret_number(secret_number, n)
    return $cache_2[secret_number] if $cache_2.has_key?("#{n}_#{secret_number}")

    n.times do
        secret_number = generate_secret_number(secret_number)
    end
    
    $cache_2["#{n}_#{secret_number}"] = secret_number

    return secret_number
end

input = File.read(file_path).split("\n").map(&:to_i)


sum = 0
input.each do |secret_number|
    sum += generate_nth_secret_number(secret_number, 2000)
end

puts sum