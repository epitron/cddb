class Array
  def squash
    self.flatten.compact.uniq
  end
end

class ActiveRecord::Base
  def self.[](n)
    find n
  end
end