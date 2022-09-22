tree = {
    value: 1,
    left: {
      value: 2,
      left: { value: 4 },
      right: { value: 5 },
    },
    right: {
      value: 3,
      left: { value: 6 },
      right: { value: 7 },
    },
  }
   
  def invert_tree(tree)
      swap_left_right(tree)
      tree.each do|key,value|
          if value.is_a?(Hash) 
             invert_tree(value)
          end 
      end
  end 
  
  def swap_left_right(tree)
      if tree[:left]!=nil and tree[:right]!=nil
          tree[:left],tree[:right] = tree[:right],tree[:left]
      end
  end
  
  puts tree
  invert_tree(tree)
  puts tree 