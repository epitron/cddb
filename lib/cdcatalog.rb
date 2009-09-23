#%w[rubygems fastercsv].each { |r| require r }
require 'fastercsv'

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
#################################################################################

module CDCatalog

  #################################################################################

  class Row

    FIELDS = :name, :comment, :size, :type, :date, :lent_to, :reserved, :location, :disc_path
    attr_accessor *FIELDS

    #################################################################################
    def initialize(row)
      #["Name", "Comments", "Size", "Type", "Date Modified", "Lent to", "Disk Location", "Location", "Path", nil]
      #["DitherTest.java", "", "10 KB (9,409 Bytes)", "JAVA File", "2/9/2002 1:56:32 PM", nil, "", "\\\\My Collection\\Appz/Warez\\Linux Warez #1\\JBuilder v5.0 Enterprise (Linux)\\Linux\\resource\\jre\\demo\\applets\\DitherTest\\", "G:\\JBuilder v5.0 Enterprise (Linux)\\Linux\\resource\\jre\\demo\\applets\\DitherTest\\DitherTest.java", nil]
      #@name, @comments, @size, @type, @date, @lent_to, @disc_location, @location, @path, tmp = row
      case row
        when Array
          FIELDS.each_with_index do |field,i|
            send("#{field}=", row[i])
          end
        when Hash
          row.each do |key, val|
            send("#{key}=", val)
          end
      end
    end

    #################################################################################
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

    #################################################################################
    def [](key)
      key = key.to_sym
      raise "Invalid key: #{key.inspect}" unless FIELDS.include? key
      send(key)
    end

    #################################################################################
    def to_hash
      Hash[ *FIELDS.map { |field| [field, send(field)] }.flatten ]
    end

  end

  #################################################################################

  class Parser
    include Enumerable
    attr_accessor :path

    #################################################################################
    def initialize(path)
      raise "File not found: #{path.inspect}" unless File.exists? path
      @path = path
    end

    #################################################################################
    def each
      FasterCSV.open(path) do |csv|
        csv.each_with_index do |row,i|
          next if i == 0
          row = Row.new(row)
          #p [i, row.location, row.name]
          yield row
        end
      end
    end
  end

  #################################################################################
end

