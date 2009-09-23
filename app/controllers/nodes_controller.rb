class NodesController < ApplicationController
  def index

    #json  : [
    #    { attributes: { id : "pjson_1" }, state: "open", data: "Root node 1", children : [
    #      { attributes: { id : "pjson_2" }, data: { title : "Custom icon", icon : "../media/images/ok.png" } },
    #      { attributes: { id : "pjson_3" }, data: "Child node 2" },
    #      { attributes: { id : "pjson_4" }, data: "Some other child node" }
    #    ]},
    #    { attributes: { id : "pjson_5" }, data: "Root node 2" }
    #  ]

    if i = params[:id]
      if i == "0"
        root = Node.root
      else
        root = Node.find(i)
      end
    else
      root = Node.root
    end

    @nodes = root.children

    respond_to do |format|
      format.json { render :json=>@nodes.to_json }
    end
  end
  
  def show

    @node = Node[params[:id]]

    if request.xhr?
      render :layout=>false
    end

  end

end
