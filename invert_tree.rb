class Node
    attr_accessor :value, :left, :right
    def initialize(value = nil)
        @value = value 
    end
end

class BinaryTree
    attr_accessor :root
    def initialize
        @root = Node.new 
    end
end

def create_binary_tree(tree_elements)
    tree = BinaryTree.new
    tree.root = insert_element_into_binary_tree(tree_elements, tree.root, 0)
    invert_tree(tree.root) 
    p print_invert_tree(tree.root)
end

def insert_element_into_binary_tree(tree_elements, node, index)
    return node if index > tree_elements.size
    temp = Node.new(tree_elements[index])
    root = temp
    root.left = insert_element_into_binary_tree(tree_elements, root.left, index * 2 + 1)
    root.right = insert_element_into_binary_tree(tree_elements, root.right, index * 2 + 2)
    root
end

def invert_tree(node)
    if node == nil
        return nil 
    end
    node_to_invert = node.left 
    node.left = invert_tree(node.right)
    node.right = invert_tree(node_to_invert)
    return node 
end 

def print_invert_tree(root)
    values_in_tree = []
    return values_in_tree if root.nil?   
    tree_values = []
    tree_values << root     
    while !(tree_values.empty?)
        number_of_values_in_level = tree_values.length
        level_by_level_elements = []
        number_of_values_in_level.times do
          node = tree_values.shift
          level_by_level_elements << node.value
          tree_values << node.left unless node.left.nil?
          tree_values << node.right unless node.right.nil?
        end
        values_in_tree << level_by_level_elements
    end
    return values_in_tree.join(' ').split(' ').map(&:to_i)
end

puts "Enter the tree elements"
tree_elements = gets.split(',').map(&:to_i)
create_binary_tree(tree_elements)