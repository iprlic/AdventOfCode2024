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


$sequences = {}
def generate_nth_secret_number(secret_number, n)
    start = secret_number
    prev_price = secret_number % 10
    prices = [prev_price]
    diffs = []
    customer_sequences = {}

    n.times do |i|
        secret_number = generate_secret_number(secret_number)
        price = secret_number % 10
        diff = price - prev_price
        prev_price = price
        diffs << diff
        prices << price

        if i > 3
            seq = diffs[i-3..i].join(',')
            next if customer_sequences.has_key?(seq)
            customer_sequences[seq] = prices[i+1]
        end
    end

    customer_sequences.each do |seq, price|
        $sequences[seq] ||= []
        $sequences[seq] << price
    end
    return secret_number
end

input = File.read(file_path).split("\n").map(&:to_i)


sum = 0
input.each do |secret_number|
    sum += generate_nth_secret_number(secret_number, 2000)
end


puts $sequences.map { |seq, prices| prices.sum }.max

