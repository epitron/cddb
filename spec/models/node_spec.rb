require File.dirname(__FILE__) + '/../spec_helper'

require 'cdcatalog'

describe Node do

  fixtures :nodes

  before(:each) do
    @hashes = [
      {:location=>"\\\\My Collection\\Appz/Warez\\",
       :type=>"Custom Record",
       :disc_path=>nil,
       :comment=>"157",
       :date=>nil,
       :lent_to=>nil,
       :size=>nil,
       :name=>"Visual Studio 2005",
       :reserved=>""},
      {:location=>"\\\\",
        :type=>"Collection Folder",
        :disc_path=>nil,
        :comment=>"The sample collection contains CDs, saparate FILES and BOOKs at \\\\My Collection\\_My Books",
        :date=>nil,
        :lent_to=>nil,
        :size=>nil,
        :name=>"My Collection",
        :reserved=>""},
      {:location=>"\\\\My Collection\\Appz/Warez\\",
        :type=>"CD-ROM Drive",
        :disc_path=>"G:\\",
        :comment=>"",
        :date=>nil,
        :lent_to=>nil,
        :size=>729996279,
        :name=>"Linux Warez #1",
        :reserved=>""},
      {:location=>"\\\\My Collection\\Appz/Warez\\Linux Warez #1\\backgrounds\\",
        :type=>"JPEG image",
        :disc_path=>"G:\\backgrounds\\blackstone.jpg",
        :comment=>"",
        :date=>"9/10/2001 12:36:22 PM",
        :lent_to=>nil,
        :size=>14575,
        :name=>"blackstone.jpg",
        :reserved=>""},
    ]

    @rows = @hashes.map do |hash|
      CDCatalog::Row.new hash
    end

    @path = "\\\\a\\b\\c\\"
  end

  it "should have a root node" do
    Node.root.should_not be_nil
  end


  it "should split location" do
    node_names = Node.split_location(@path)
    node_names.should == %w[a b c]
  end

  it "splitting \\\\ should return an empty array" do
    Node.split_location("\\\\").should be_empty
  end

  it "should mkdir_p and walk" do
    node_names = Node.split_location(@path)

    Node.mkdir_p(@path)
    Node.at(@path).should_not be_nil

    nodes = []
    Node.walk(node_names) { |n| nodes << n }
    nodes.size.should == 3
    nodes.map(&:name).should == node_names
  end

  it "^-- should import records --^" do
    for row in @rows
      Node.create_from_row(row, zombies=true)
    end
    Node.display_tree
  end

  it "^-- should show a pretty tree --^" do
    Node.mkdir_p(@path)
    Node.mkdir_p("\\\\blah\\stuff\\")
    Node.mkdir_p("\\\\blah\\otherstuff\\")
    Node.mkdir_p("\\\\blah\\otherstuff\\sweet\\")
    Node.mkdir_p("\\\\a\\what\\")
    Node.mkdir_p("\\\\a\\yay\\")
    Node.display_tree
  end

  it "should destroy children's children" do
    Node.mkdir_p(@path)
    Node.root.children.find_by_name("a").destroy
    Node.find_by_name("a").should be_nil
    Node.find_by_name("b").should be_nil
    Node.find_by_name("c").should be_nil
  end

  it "should destroy ALL CHILDREN" do
    Node.mkdir_p(@path)
    Node.root.children.clear
    Node.find_by_name("a").should be_nil
    Node.find_by_name("b").should be_nil
    Node.find_by_name("c").should be_nil
  end

  it "children should not destroy parent" do
    Node.mkdir_p(@path)
    Node.find_by_name("b").destroy
    Node.find_by_name("a").should_not be_nil
    Node.find_by_name("c").should be_nil
    Node.root.should_not be_nil
  end

=begin
  it "should have working options dropdowns" do
    %w(product_type color payment_method size pages paper_type).each do |dropdown|
      eval("@job.options_for_#{dropdown}").should_not be_blank
    end
  end
  
  it "should limit scope for available_product_types" do
    types = @job.available_product_types
    types.should_not be_empty
    pp types
  end

  it "should require confirmation if there are no proofs" do
    @job.needs_to_confirm_no_proof?.should == true
    @job.options << OptionCategory.proofs.options.first
    @job.needs_to_confirm_no_proof?.should == false
  end

  it "should have categorized options" do
    @job.categorized_options.should_not be_empty
  end
=end
end
