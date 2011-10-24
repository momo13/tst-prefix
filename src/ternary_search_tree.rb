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
      
      while( node && position < string.size )
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
    
    def insert(pattern)
      node = root
      parent = nil
      contained = false #prefix contained
      position = 0
      is_part = node ? true : false
      
      while( is_part && !contained )
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
          if( position == pattern.size ) # cut node here, as this is a shorter prefix
            contained = true
            node.pattern = pattern
            node.equal = nil
          elsif ( node.pattern != nil )
            contained = true # there is already a shorter prefix
          else 
            node = node.equal
          end
        end
      end
      
      if( !contained )
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
    
    def child_node(pattern, position)
      child_pattern = ( position == pattern.length - 1 ) ? pattern : nil
      child = Node.new( pattern[ position ], nil, nil, nil, child_pattern )  
    end
    
    class NodePosition 
      attr_accessor :y, :x, :node
      
      def initialize( y, x, node )
        @y = y
        @x = x
        @node = node
      end
       
    end
    
    def print # This solution only doesn't work !!! You have to know the broadest level
      min_x = 0
      max_x = 0
      max_y = 0
      matrix = Hash.new { |y_hash, y_key| y_hash[y_key] = Hash.new { |x_hash, x_key| x_hash[x_key] = nil } }
      nodes = [ NodePosition.new(0, 0, root) ]
      while(nodes.size > 0)
        node_position = nodes.pop
        nodes.push NodePosition.new( node_position.y + 1, node_position.x + 1, node_position.node.higher ) if node_position.node.higher
        nodes.push NodePosition.new( node_position.y + 1, node_position.x, node_position.node.equal ) if node_position.node.equal
        nodes.push NodePosition.new( node_position.y + 1, node_position.x - 1, node_position.node.lower ) if node_position.node.lower
        matrix[node_position.y][node_position.x] = node_position.node.split_char
        min_x = [min_x, node_position.x].min
        max_x = [max_x, node_position.x].max
        max_y = [max_y, node_position.y].max
        puts "#{node_position.node.split_char}: #{nodes.map {|n| [n.node.split_char, n.y, n.x] }}"
      end
      puts
      puts "Tree:"
      (0..max_y).each { |y|
        line = ""
        (min_x..max_x).each { |x|
          elem = matrix[y][x]
          line += elem ? elem : " "
        }
        puts line
      }
    end
  end
end