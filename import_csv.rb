%w[config/environment cdcatalog pp].each { |r| require r }

if $0 == __FILE__
  #clearline = "\h" * 80
  record_count    = 0
  #csvfile = "data/catalog.csv"
  csvfile = "data/small-catalog.csv" 

  CDCatalog::Parser.new(csvfile).each do |r|
    record_count += 1

    p r.location

    #Node.at_location r.location

    if record_count % 1768 == 0
      #print clearline
      print "  |_ #{record_count} records..."
      STDOUT.flush
    end

  end

  #print clearline
  puts "  |_ #{record_count} records..."

end