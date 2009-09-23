# == Schema Information
# Schema version: 20090921221646
#
# Table name: nodes
#
#  id         :integer(4)      not null, primary key
#  parent_id  :integer(4)      
#  type       :string(255)     
#  name       :string(255)     
#  comment    :text            
#  disc_path  :string(255)     
#  date       :datetime        
#  created_at :datetime        
#  updated_at :datetime        
#

# TODO: Classify files as "video", "audio", "text", etc. for searches

class Node < ActiveRecord::Base

  belongs_to  :parent,    :class_name => "Node",  :foreign_key => "parent_id"
  has_many    :children,  :class_name => "Node",  :foreign_key => "parent_id"

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
    "Virtual Folder"        => "Collection",
    "Custom Record"         => "VirtualDisc",
    "CD-ROM Drive"          => "Disc",
    "File Folder"           => "Folder",
    "List of Keywords"      => :skip,
    "*"                     => "File",
  }

  def self.translated_type(type)
    TYPE_TRANSLATION_TABLE[type] || TYPE_TRANSLATION_TABLE["*"]
  end

  ################################################################################################

  IMPORT_ATTRIBUTES = [:name, :type, :disc_path, :comment, :date, :size,]

  def self.create_from_row(row, zombies=false)
    p [:creating, row.location, row.name]
    if zombies
      p [:making_zombie]
      Node.mkdir_p(row.location)
      #display_tree
    end

    parent = walk(row.location)
    unless node = parent.children.find_by_name(row.name)
      node = parent.children.new 
    end

    IMPORT_ATTRIBUTES.each do |attr|
      node.send("#{attr}=", row.send(attr))
    end

    node.type = translated_type(node.type)

    node.save!

    display_tree
    puts
  end

  ################################################################################################

  def inspect
    "[\"#{name}\": id=#{id}, parent=#{parent_id.inspect}, size=#{size}, type=#{type || "ZOMBIE"}]"
  end

end


## Types:
#["Local Disk", "WinRAR archive", "JPEG image", "Archive", "Custom Record", "List of Contacts", "Virtual folder",
#"Collection Folder", "PNG image", "List of Keywords", "Text Document", "SH File", "CD-ROM Drive",
#"Foxit Reader Document", "File Folder", "T File"]

