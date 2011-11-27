module TernarySearchTree

  class Node
    
    attr_accessor :split_char, :lower, :equal, :higher, :pattern
  
    def initialize( split_char, lower = nil, equal = nil, higher = nil, pattern = nil )
      @split_char = split_char
      @pattern = pattern #stores a pattern if the path to it contains the inserted pattern
      @lower = lower
      @equal = equal
      @high = higher
    end
      
  end
  
  class Tree
    
    attr_accessor :root
    
    def search( string )
      node = root
      parent = nil
      found = false
      position = 0
      
      while( node && (position < string.size) )
        parent = node
        if( string[position] < node.split_char )
          node = node.lower
        elsif( string[position] > node.split_char )
          node = node.higher
        else
          position += 1
          if( !node.pattern.nil? ) # optimize with node.equal.nil?
            found = true
          end
          node = node.equal
        end
      end
      
      return found, parent
    end
    
    def insert( pattern )
      node = root
      parent = nil
      contained = false #prefix contained
      position = 0
      is_part = node ? true : false
      
      while( is_part && !contained ) # sub-path is still in tree && complete path is not contained
        parent = node
        
        if( pattern[position] < node.split_char )
          if ( !node.lower )
            node.lower = child_node( pattern, position )
            is_part = false
            position += 1
          end 
                   
          node = node.lower
        elsif( pattern[position] > node.split_char )
          
          if ( !node.higher )
            node.higher = child_node( pattern, position )
            is_part = false
            position += 1
          end
          
          node = node.higher
        else
          position += 1
          
          if( position == pattern.size ) # cut node here, as this we can insert a shorter prefix
            contained = true
            node.pattern = pattern
            node.equal = nil
          elsif ( node.pattern != nil )
            contained = true # we found a shorter prefix for the path
          else
            
            node = node.equal
          end
        end
      end
      
      if( !contained ) # continue if the path is not yet part of the tree
        while( position < pattern.length )
          parent = node
          node = child_node( pattern, position )
          if parent
            parent.equal = node
          else
            @root = node
          end
          
          position += 1
        end
      end
      
      node
    end
    
    def child_node( pattern, position )
      child_pattern = ( position == pattern.length - 1 ) ? pattern : nil
      child = Node.new( pattern[ position ], nil, nil, nil, child_pattern )  
    end
  end

end