input_file_path = File.join(File.dirname(__FILE__), 'input.txt')
input = File.readlines(input_file_path)

class Node
  attr_reader :name

  def initialize(name)
    @name = name
    @children = []
  end

  def add_child(parent_name, child_node)
    if parent_name == @name
      @children << child_node
      return true
    end

    @children.any? do |child|
      child.add_child(parent_name, child_node)
    end
  end

  def find(name)
    return self if @name == name

    @children.each do |child|
      match = child.find(name)
      return match unless match.nil?
    end

    nil
  end

  def describe(level = 0)
    nodes = []
    @children.each do |child|
      nodes.concat(child.describe(level + 1))
    end
    nodes << {name: @name, depth: level}
    nodes.flatten
  end
end

nodes = []

def find_parent(nodes, name)
  node = nodes.find do |n|
    !n.find(name).nil?
  end

  if node.nil?
    node = Node.new(name)
    nodes << node
  end

  node
end

def find_child(nodes, name)
  index = nodes.find_index do |n|
    n.name == name
  end

  if index.nil?
    Node.new(name)
  else
    nodes.slice!(index)
  end
end

input.each do |orbit|
  parent_name, child_name = orbit.chomp!.split(')')
  parent = find_parent(nodes, parent_name)
  child = find_child(nodes, child_name)

  parent.add_child(parent_name, child)
end

root = nodes.first
puts "tree: #{root.describe}"

answer = root.describe.sum do |node|
  node[:depth]
end

puts "answer #{answer}"
