class HomeController < ApplicationController

  def index
  end

  def search
    if query = params[:q]
      search   = Node.search(query)
      @results  = search[:nodes].map{ |node| (node.type == "Disc") ? node.children : node } # expand Discs
      @words    = search[:words]
      @terms    = search[:terms]
    end
  end

end


