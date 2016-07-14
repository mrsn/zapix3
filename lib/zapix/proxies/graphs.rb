require_relative 'base'

class Graphs < Base
  def get_all_graph_ids_for(options)
    graphs_with_names_and_ids = []
    graphs = client.graph_get(options)

    graphs.each do |g|
      graphs_with_names_and_ids <<
      { 
        'name' => g['name'],
        'id' => g['graphid']
      }
    end

    graphs_with_names_and_ids
  end
end
