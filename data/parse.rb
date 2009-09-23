%w[rubygems fastercsv pp set].each { |r| require r }

=begin

{:path=>"G:\\backgrounds\\Fractal",
 :type=>"File Folder",
 :comments=>"",
 :date=>"8/31/2001 2:34:10 AM",
 :name=>"Fractal",
 :lent_to=>nil,
 :disc_location=>"",
 :location=>"\\\\My Collection\\Appz/Warez\\Linux Warez #1\\backgrounds\\",
 :size=>3999564}

{:path=>"G:\\backgrounds\\all-backgrounds.zip\\LumpyGreenTropicalIslands.jpg",
 :type=>"JPEG image",
 :comments=>"",
 :date=>"8/31/2001 1:42:34 AM",
 :name=>"LumpyGreenTropicalIslands.jpg",
 :lent_to=>nil,
 :disc_location=>"",
 :location=>
  "\\\\My Collection\\Appz/Warez\\Linux Warez #1\\backgrounds\\all-backgrounds.zip\\Nature\\",
 :size=>113384}


=end

class Row
  
  FIELDS = :name, :comments, :size, :type, :date, :lent_to, :reserved, :location, :disc_path
  attr_accessor *FIELDS
  
  def initialize(row)
    #["Name", "Comments", "Size", "Type", "Date Modified", "Lent to", "Disk Location", "Location", "Path", nil]
    #["DitherTest.java", "", "10 KB (9,409 Bytes)", "JAVA File", "2/9/2002 1:56:32 PM", nil, "", "\\\\My Collection\\Appz/Warez\\Linux Warez #1\\JBuilder v5.0 Enterprise (Linux)\\Linux\\resource\\jre\\demo\\applets\\DitherTest\\", "G:\\JBuilder v5.0 Enterprise (Linux)\\Linux\\resource\\jre\\demo\\applets\\DitherTest\\DitherTest.java", nil]
    #@name, @comments, @size, @type, @date, @lent_to, @disc_location, @location, @path, tmp = row
    FIELDS.each_with_index do |field,i|
      send("#{field}=", row[i])
    end
  end
  
  def size=(v)
    if v.is_a? Integer or v.nil?
      @size = v
      return
    end
    
    if v =~ /([\d,]+) Bytes/
      @size = $1.gsub(/[^\d]/, '').to_i
    else
      raise "Couldn't parse size: #{v.inspect}"
    end
  end

  def [](key)
    key = key.to_sym
    raise "Invalid key: #{key.inspect}" unless FIELDS.include? key
    send(key)
  end
  
  def to_hash
    Hash[ *FIELDS.map { |field| [field, send(field)] }.flatten ]
  end
    
end

class Entry
  FIELDS = :name, :path, :size, :date
  attr_accessor *FIELDS
end

class Folder
  attr_accessor :children
  
  def initialize(children=[])
    raise "WTF? I can only handle Folders!" unless children.all? { |child| child.is_a? Folder }
    @children = children
  end
end


class Catalog
  def initialize
    @catalog = {}
  end
  
  def find_folder(path)
    
  end
  
  def <<(row)
    @catalog[row.location] = row
    
  end
end

if $0 == __FILE__
  
  puts "* Reading CSV..."
  
  #FasterCSV.open("catalog.csv", :headers => :first_row) do |csv|
  
  FasterCSV.open("small-catalog.csv") do |csv|
    first_row = true

    record_count    = nil
    types           = Hash.new { |hash, key| hash[key] = [] }
        
    csv.each_with_index do |row,record_count|
      if first_row; first_row = false; next; end
      r = Row.new(row)
      #pp r.to_hash
      
      types[r[:type]] << r.to_hash
      
      if record_count % 1768 == 0
        puts "  |_ #{record_count} records..."
      end      
    end
    
    puts "  |_ #{record_count} records..."

    puts "Types:"
    #pp types
    types.each do |key, val|
      puts "#" * 60
      puts "Type: #{key.inspect}"
      puts "#" * 60
      pp val
    end
    puts
    
  end
  
end