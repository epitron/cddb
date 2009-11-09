# == Schema Information
# Schema version: 20090921221646
#
# Table name: nodes
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     
#  parent_id  :integer(4)      
#  lent_to_id :integer(4)      
#  type       :string(255)     
#  comment    :text            
#  disc_path  :string(255)     
#  crate_id   :integer(4)      
#  sleeve_id  :integer(4)      
#  size       :integer(4)      
#  date       :datetime        
#

# TODO: Classify files as "video", "audio", "text", etc. for searches

require 'set'

class Node < ActiveRecord::Base

  include ActionView::Helpers::NumberHelper

  belongs_to  :parent,    :class_name => "Node",  :foreign_key => "parent_id", :counter_cache => :children_counter
  has_many    :children,  :class_name => "Node",  :foreign_key => "parent_id", :dependent => :destroy

  ################################################################################################

  def self.[](value)
    if value.is_a? String
      if value =~ /^\d+$/
        find(value)
      else
        find_by_name(value)
      end
    else
      super
    end
  end

  ################################################################################################

  def self.inheritance_column
    nil
  end

  ################################################################################################

  def self.root
    find(1)
  end

  ################################################################################################

  def self.walk(node_names)
    node_names = split_location(node_names) if node_names.is_a? String
    cur = root
    for node_name in node_names
      cur = cur.children.find_by_name(node_name)
      raise "Can't find #{node_name.inspect} in #{row.location.inspect}" unless cur
      yield cur if block_given?
    end
    cur
  end

  def self.at(location)
    walk(location)
  end

  def self.split_location(location)
    location.scan(/([^\\]+)\\*/).flatten
  end

  def self.mkdir_p(location)
    node_names = split_location(location)
    cur = Node.root
    for node_name in node_names
      unless child = cur.children.find_by_name(node_name)
        child = cur.children.create(:name=>node_name)
      end
      cur = child
    end
  end

  #
  # Depth-first traversal
  #
  def self.visit_all_with_level(root=nil, level=0, &block)
    if root
      cur = root
    else
      cur = Node.root
    end

    yield cur, level
    for child in cur.children
      visit_all_with_level(child, level+1, &block)
    end
  end
  
  def self.display_tree
    visit_all_with_level { |n, level| puts "  "*level + n.inspect }
  end

  ################################################################################################

  TYPE_TRANSLATION_TABLE = {
    "Collection Folder"     => "Collection",
    "Virtual folder"        => "VirtualFolder",
    "Custom Record"         => "VirtualDisc",
    "CD-ROM Drive"          => "Disc",
    "File Folder"           => "Folder",
    "List of Keywords"      => :skip,
    "List of Contacts"      => :skip,
    "*"                     => "File",
  }

  def self.translated_type(type)
    TYPE_TRANSLATION_TABLE[type] || TYPE_TRANSLATION_TABLE["*"]
  end

  ################################################################################################

  def self.create_from_row(row, zombies=false)

    translated_type = translated_type(row.type)
    return if translated_type == :skip

    if zombies
      Node.mkdir_p(row.location)
      #display_tree
    end

    parent = walk(row.location)
    unless node = parent.children.find_by_name(row.name)
      node = parent.children.new 
    end

    node.name       = row.name
    node.disc_path  = row.disc_path
    node.date       = row.date
    node.size       = row.size
    node.comment    = row.comment unless translated_type == "File"
    node.type       = translated_type

    node.save!
  end

  ################################################################################################

  def self.destroy_all
    Node.root.children.clear
  end

  ################################################################################################

  UNCONTAINERS = Set.new %w[VirtualDisc File]

  def stats
    result = []

    result << [ "Total size", "#{number_to_human_size(size)} (#{number_with_delimiter(size)} bytes)" ] if size

    unless UNCONTAINERS.include? type
      result << [ "Contains", "#{children_count} items" ]
    end

    result << [ "Type", type ]
    result << [ "Date", date ]
    result << [ "Disc Path", disc_path ]

    if comment
      if comment =~ /^\d+$/
        result << [ "Sleeve #", comment ]
      else
        result << [ "Comment", comment ]
      end
    end

    result
  end

  ################################################################################################

  def self.search(query)
    terms = []
    words = []

    for term in query.split
      if term[0..0] == "-"
        terms << term
      else
        terms << "+#{term}"
        words << term
      end
    end

    results = find(:all, :conditions=>["MATCH(name) AGAINST (? IN BOOLEAN MODE)", terms.join(' ')])

    {
      :results    => results,
      :words      => words,
      :terms      => terms,
    }
  end

  ################################################################################################

  def containing_disc
    p self
    cur = self
    until cur.disc? or cur.root?
      cur = cur.parent
    end
    cur
  end

  def sleeve
    comment if comment =~ /^\d+$/
  end

  def relative_path
    $1 if disc_path =~ /(.+)#{Regexp.escape name}/
  end

  def root?
    self.type == "Root"
  end

  def disc?
    self.type == "Disc"
  end

  def icon_path
    "/images/icons/#{css_class}.png"
  end

  def css_class
    self.type.downcase
  end

  ################################################################################################

  def inspect
    "[\"#{name}\": id=#{id}, parent=#{parent_id.inspect}, size=#{size}, type=#{type || "ZOMBIE"}]"
  end

  ################################################################################################

  def to_json(*args)
    result = {
      :attributes => { :id=>self.id },
      :data => { :title=>self.name, :attributes=>{:class=>self.css_class} },
      #:children => self.children.map(&:to_json).join(", "),
    }

    result[:state] = "closed" if children_count > 0

    result.to_json
  end

end


## Types:
#["Local Disk", "WinRAR archive", "JPEG image", "Archive", "Custom Record", "List of Contacts", "Virtual folder",
#"Collection Folder", "PNG image", "List of Keywords", "Text Document", "SH File", "CD-ROM Drive",
#"Foxit Reader Document", "File Folder", "T File"]

