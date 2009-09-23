# ActiveRecordEach

class ActiveRecord::Base
  class << self
    # Each goes througt all entries in a model, without loading all
    # You can pass to it any parameter like find. See find for options you can pass
    #
    # ==== Examples:
    #
    #   # Goes throught all users wich name starts by g
    #   User.each (:conditions => "users.name LIKE 'g%'") do |u|
    #     puts u.name
    #   end
    #
    def each(options = {}, &block)
      options = {:limit => 100}.update(options)
      
      validate_find_options(options)
      set_readonly_option!(options)

      # if we're passed order then fast mode MAY not work, so we'll stick
      # with the slow mode
      if options[:order]
        slow_each(options, &block)
      else
        fast_each(options, &block)
      end
    end
    
    def slow_each(options, &block)
      0.step(count(options), options[:limit]) do |offset|
        find(:all, options.merge(:offset => offset)).each(&block)
      end      
    end

    # because :offset can be quite slow for large tables as really the DB
    # still has to execute the query and then seek into the query to return 
    # you the row you want.
    # using the primary_key allows us to piggy back on the index
    def fast_each(options, &block)
      # not all the backends always sort primay_key columns so do it manually
      options.update(:order => "#{table_name}.#{primary_key} ASC")
      
      # find the first id
      i = minimum("#{table_name}.#{primary_key}", options) or return
      i -= 1 # one less so > in find matches this one

      # as long as we keep finding objects, keep going
      loop do
        records = with_scope(:find => {:conditions => [ "#{table_name}.#{primary_key} > ?", i]} ) do
          find(:all, options)
        end
        unless records.empty?
          records.each(&block)
          i = records.last.send(primary_key)
        else
          break
        end
      end
    end

    # Invokes block once for each element of self. Creates a new array containing the values returned by the block
    #
    # ==== Example:
    #
    #   #Get password from md5hash
    #   clean_password = User.map { |u| magic_recover_password(u.md5) }
    #
    def map(options = {})
      validate_find_options(options)
      set_readonly_option!(options)

      returning Array.new do |results|
        each(options) do |i|
          results << yield(i)
        end
      end
    end

    # Collect is an alias for map
    alias_method :collect, :map

  end
end
