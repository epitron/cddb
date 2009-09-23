class Listy
  attr_accessor :list
  
  def initialize(list=[])
    @list = list
  end
end

a, b = Listy.new, Listy.new

a.list << 5
p a.list
p b.list