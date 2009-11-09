class HomeController < ApplicationController

  def index
  end

  def search
    if query = params[:q]
      search   = Node.search(query)
      @results  = search[:results]
      @words    = search[:words]
      @terms    = search[:terms]
    end
  end

end


