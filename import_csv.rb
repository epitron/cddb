#!/usr/bin/ruby
%w[config/environment cdcatalog pp].each { |r| require r }

if $0 == __FILE__
  clearline = "\b" * 80
  record_count    = 0
  if ARGV[0] and ARGV[0] == "-f"
    csvfile = "data/catalog.csv"
  else
    csvfile = "data/small-catalog.csv"
  end

  puts "* Emptying database..."
  Node.destroy_all
  puts "  |_ #{Node.count} nodes left"
  puts

  puts "* Importing #{csvfile}..."
  CDCatalog::Parser.new(csvfile).each do |row|
    record_count += 1

    if record_count % 25 == 0
      print clearline
      print "  |_ #{record_count} records..."
      STDOUT.flush
    end

    Node.create_from_row(row)

  end

  print clearline
  puts "  |_ #{record_count} records..."

  #Node.display_tree

end
