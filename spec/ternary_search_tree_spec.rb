require "#{File.dirname(__FILE__)}/../src/ternary_search_tree"

describe TernarySearchTree do
  
  describe "Tree" do
    
    it "stores the root" do
      tree = TernarySearchTree::Tree.new
      tree.root.should be_nil
    end
    
    it "inserts in an empty tree - one char" do
      tree = TernarySearchTree::Tree.new
      tree.insert("a")
      "a"[0].should == "a"
      
      tree.root.should_not be_nil
      tree.root.split_char.should == "a"
      tree.root.pattern.should == "a"
    end

    it "inserts in an empty tree" do
      tree = TernarySearchTree::Tree.new
      leaf = tree.insert("abc")
      
      tree.root.should_not be_nil
      tree.root.split_char.should == "a"
      tree.root.pattern.should be_nil
      tree.root.lower.should be_nil
      tree.root.higher.should be_nil
      
      leaf.pattern.should == "abc"
      leaf.split_char.should == "c"
      leaf.lower.should be_nil
      leaf.equal.should be_nil
      leaf.higher.should be_nil
    end

    it "insert two strings" do
      tree = TernarySearchTree::Tree.new
      leaf1 = tree.insert("abc")
      leaf2 = tree.insert("ace")
      
      tree.root.should_not be_nil
      tree.root.split_char.should == "a"
      tree.root.pattern.should be_nil
      tree.root.lower.should be_nil
      tree.root.higher.should be_nil
      
      tree.root.equal.lower.should be_nil
      tree.root.equal.higher.should_not be_nil
      tree.root.equal.higher.split_char.should == "c"
      
      leaf2.pattern.should == "ace"
      leaf2.split_char.should == "e"
      leaf2.lower.should be_nil
      leaf2.equal.should be_nil
      leaf2.higher.should be_nil
    end
    
    it "inserting a shorter pattern is cutting a node" do
      tree = TernarySearchTree::Tree.new
      leaf1 = tree.insert("abc")
      
      tree.root.equal.equal.pattern.should == "abc"
      
      leaf2 = tree.insert("ab")
      tree.root.equal.equal.should be_nil
      tree.root.equal.pattern.should == "ab"
    end

  end
    
  describe "Node" do
    
    it "stores a split character" do
      node = TernarySearchTree::Node.new("s")
      
      node.split_char.should == "s"
    end

  end
end