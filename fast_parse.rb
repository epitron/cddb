%w[rubygems fastercsv pp].each { |r| require r }

if $0 == __FILE__
  path = "data/catalog.csv"
  #path = "data/small-catalog.csv"

  types           = Hash.new { |hash, key| hash[key] = [] }
  record_count    = 0
  stop_at = 50_000

  puts "* Scanning #{path}..."
  FasterCSV.open(path) do |csv|
    csv.each do |row|

      #pp r.to_hash
      record_count += 1

      #types[r[:type]] << r.to_hash

      if record_count % 1768 == 0
        puts "  |_ #{record_count} records..."
      end

      break if record_count == stop_at

    end
  end


  puts "  |_ #{record_count} records..."

  puts "total records: #{record_count}"
  puts

end
