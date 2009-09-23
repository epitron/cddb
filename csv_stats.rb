%w[config/environment cdcatalog pp].each { |r| require r }

if $0 == __FILE__
  path = "data/catalog.csv"
  #path = "data/small-catalog.csv"

  types           = Hash.new { |hash, key| hash[key] = [] }
  record_count    = 0

  puts "* Scanning #{path}..."
  CDCatalog::Parser.new(path).each do |r|
    #pp r.to_hash
    record_count += 1

    types[r[:type]] << r.to_hash

    if record_count % 1768 == 0
      puts "  |_ #{record_count} records..."
    end

  end

  puts "  |_ #{record_count} records..."

  puts "Types:"
  #pp types
  types.sort_by{|k,v| v.size}.each do |type, rows|
    p [type, rows.size]
  end

  puts "total records: #{record_count}"
  puts

end
