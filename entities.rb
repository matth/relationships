require 'rubygems'
require 'open-uri'
require 'json'

class Entity

  def self.cache
    @cache ||= {}
  end

  def self.data(id)
    JSON.parse(open(url(id)).readlines.join(""))
  end

  def self.url(id)
    "http://api.littlesis.org/entity/#{id}.json?_key=6f1b1376ec9f3f00824c8523bd32ce9a3bfbe408"
  end

  def self.get(id)
    if !cache.key?(id.to_sym)
      d = data(id)
      cache[id.to_sym] = {
        :name         => d["Response"]["Data"]["Entity"]["name"],
        :primary_type => d["Response"]["Data"]["Entity"]["primary_type"]
      }
    end
    {id.to_sym => cache[id.to_sym]}
  end

end

class Relationships

  def self.cache
    @cache ||= {}
  end

  def self.url(id)
    "http://api.littlesis.org/entity/#{id}/relationships.json?_key=6f1b1376ec9f3f00824c8523bd32ce9a3bfbe408"
  end

  def self.data(id)
    JSON.parse(open(url(id)).readlines.join(""))
  end

  def self.get(id)
    if !cache.key?(id.to_sym)
      cache[id.to_sym] = data(id)["Response"]["Data"]["Relationships"]["Relationship"].map do |relationship|
        [relationship["entity1_id"], relationship["entity2_id"]]
      end
    end
    cache[id.to_sym]
  end

end


def graph(id, depth = 0)

  p "Building graph for #{id}"

  rels = 30

  graph = {
    :entities      => {},
    :relationships => []
  }

  graph[:entities]      =  Entity.get(id)
  graph[:relationships] =  graph[:relationships] + Relationships.get(id)

  graph[:relationships].take(rels).each do |relationship|
    graph[:entities]    =  graph[:entities].merge(Entity.get(relationship[0]))
    graph[:entities]    =  graph[:entities].merge(Entity.get(relationship[1]))
  end

  p graph[:entities].keys

  graph[:relationships].each do |a, b|
    interested_in = (a == id) ? b : a
    next if interested_in == "28776" # George bush
    new_r = Relationships.get(interested_in).select do |c, d|
       p "#{c} => #{d}"
      graph[:entities].key?(c.to_sym) && graph[:entities].key?(d.to_sym)
    end
    p new_r
    graph[:relationships] = graph[:relationships] + new_r
  end

  # graph[:relationships].uniq!

  graph

end

puts graph("47858", 1).to_json