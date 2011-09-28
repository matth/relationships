require 'rubygems'
require 'open-uri'
require 'json'

def url(id)
  "http://api.littlesis.org/entity/#{id}/relationships.json?_key=6f1b1376ec9f3f00824c8523bd32ce9a3bfbe408"
end

def data(id)
  JSON.parse(open(url(id)).readlines.join(""))
end

def graph(id, depth = 0)

  p "Building graph for #{id}"

  graph = {
    :entities      => {},
    :relationships => []
  }

  data = data(id)

  graph[:entities][data["Response"]["Data"]["Entity"]["id"].to_sym] = {
    :name => data["Response"]["Data"]["Entity"]["name"],
    :primary_type => data["Response"]["Data"]["Entity"]["primary_type"]
  }

  if depth > 0

    data["Response"]["Data"]["Relationships"]["Relationship"].take(5).each do |relationship|
      graph[:relationships].push [relationship["entity1_id"], relationship["entity2_id"]]
    end

    graph[:relationships].take(5).each do |a, b|
      interested_in = (a == id) ? b : a
      next if interested_in == "28776"
      new_data  = graph(interested_in, depth - 1)
      entity_id = new_data[:entities].keys.first
      graph[:entities][entity_id] = new_data[:entities][entity_id]
      graph[:relationships] = graph[:relationships] + new_data[:relationships]
    end

    graph[:relationships].uniq!

  end

  graph

end

puts graph("47858", 4).to_json