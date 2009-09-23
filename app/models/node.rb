# TODO: Classify files as "video", "audio", "text", etc. for searches

class Node < ActiveRecord::Base
  TYPE_TRANSLATION_TABLE = {
    "Collection Folder"     => "Collection",
    "Virtual Folder"        => "Collection",
    "Custom Record"         => "VirtualDisc",
    "CD-ROM Drive"          => "Disc",
    "File Folder"           => "Folder",
    "List of Keywords"      => :skip,
    "*"                     => "File",
  }

  IMPORT_ATTRIBUTES = [:type, :disc_path, :comments, :date, :lent_to, :size, :name]

  belongs_to  :parent,    :class_name => "Node",  :foreign_key => "parent_id"
  has_many    :children,  :class_name => "Node",  :foreign_key => "parent_id"

  def self.root
    find(:first, :conditions=>{:parent_id => nil})
  end

  def self.at_location(location)
    parts = split_location(location)
    p = root
    loop do
      n = parts.shift
      p = p.children.find_by_name(n)
      return nil unless p
    end
    p
  end

  def self.split_location(location)
    location.scan(/([^\\]+)\\*/).flatten
  end

  def self.mkdir_p(location)
    parts = split_location(location)

  end


  def self.add_from_row(row)
    node = Node.new
    row.to_hash.each do |key,val|
      node.send("#{key}=", val)
    end

  end

end


## Types:
#["Local Disk", "WinRAR archive", "JPEG image", "Archive", "Custom Record", "List of Contacts", "Virtual folder",
#"Collection Folder", "PNG image", "List of Keywords", "Text Document", "SH File", "CD-ROM Drive",
#"Foxit Reader Document", "File Folder", "T File"]

