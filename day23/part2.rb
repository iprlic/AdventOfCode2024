#!/usr/bin/env ruby
# frozen_string_literal: true
require 'set'

largest_cluster = []

def expand_nodes(r, p, x, graph, largest_cluster)
    if p.empty? && x.empty?
      largest_cluster.replace(r) if r.size > largest_cluster.size
      return
    end

    pivot = (p + x).first

    (p - graph[pivot]).each do |v|
        expand_nodes(
        r + [v],
        p & graph[v],
        x & graph[v],
        graph,
        largest_cluster
      )
      p.delete(v)
      x.add(v)
    end
end


file_path = File.expand_path('input.txt', __dir__)

groups = File.read(file_path).split("\n").map{ |line| line.split('-') }

connections = {}

groups.each do |group|
    connections[group[0]] ||= []
    connections[group[0]] << group[1]
    connections[group[1]] ||= []
    connections[group[1]] << group[0]
end

graph = connections.transform_values { |neighbors| neighbors.to_set }
nodes = graph.keys.sort_by { |node| graph[node].size }


expand_nodes([], nodes.to_set, Set.new, graph, largest_cluster)
puts largest_cluster.sort.join(',')