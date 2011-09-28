require 'rubygems'
require 'json'
require 'pp'

$groups = {}

def group_for(type)
  if $groups.key?(type)
    $groups[type]
  else
    $groups[type] = $groups.keys.count + 1
  end
end

data = JSON.parse(DATA.readlines.join(""), :symbolize_names => true)

out  = {
  :nodes => [],
  :links => []
}

out[:nodes] = data[:entities].keys.map do |key|
  entity = data[:entities][key]
  {
    :name  => entity[:name],
    :group => group_for(entity[:primary_type])
  }
end

out[:links] = data[:relationships].select do |relationship|
  data[:entities].key?(relationship[0].to_sym) && data[:entities].key?(relationship[1].to_sym)
end.map do |relationship|
  {
    :source => data[:entities].keys.index(relationship[0].to_sym),
    :target => data[:entities].keys.index(relationship[1].to_sym),
    :value  => 3
  }
end

puts out.to_json

__END__
{"entities":{"47858":{"name":"Leslie A Dach","primary_type":"Person"},"1":{"name":"Wal-Mart Stores, Inc.","primary_type":"Org"},"14210":{"name":"Al Gore","primary_type":"Person"},"13407":{"name":"Patrick Leahy","primary_type":"Person"},"13191":{"name":"Hillary Clinton","primary_type":"Person"},"28670":{"name":"Democratic Congressional Campaign Committee","primary_type":"Org"},"29249":{"name":"Emily's List","primary_type":"Org"},"28668":{"name":"Bill Clinton","primary_type":"Person"},"28965":{"name":"DNC-Non-Federal Individual","primary_type":"Org"},"43244":{"name":"Edelman","primary_type":"Org"},"14467":{"name":"Geraldine Anne Ferraro","primary_type":"Person"},"13375":{"name":"Ted Kennedy","primary_type":"Person"},"13418":{"name":"Blanche Lincoln","primary_type":"Person"},"25798":{"name":"Ira S Shapiro","primary_type":"Person"},"13377":{"name":"John Kerry","primary_type":"Person"},"13762":{"name":"Tom Daschle","primary_type":"Person"},"28862":{"name":"Democratic National Committee","primary_type":"Org"},"45296":{"name":"Independent Action Inc","primary_type":"Org"},"13503":{"name":"Barack Obama","primary_type":"Person"},"29796":{"name":"Hill PAC","primary_type":"Org"},"34877":{"name":"World Resources Institute","primary_type":"Org"},"14952":{"name":"Yale University","primary_type":"Org"},"34975":{"name":"Environmental Defense","primary_type":"Org"},"33347":{"name":"Harvard Kennedy School","primary_type":"Org"}},"relationships":[["47858","1"],["47858","14210"],["47858","13407"],["47858","13191"],["47858","28670"],["47858","29249"],["47858","28668"],["47858","28965"],["47858","43244"],["47858","14467"],["47858","13375"],["47858","13418"],["47858","25798"],["47858","13377"],["47858","13762"],["47858","28862"],["47858","45296"],["47858","13503"],["47858","29796"],["47858","34877"],["47858","14952"],["47858","34975"],["47858","33347"],["47858","28862"],["47858","1"],["14210","13191"],["14210","13377"],["13375","14210"],["47858","14210"],["25798","14210"],["14467","13407"],["47858","13407"],["13762","13191"],["28668","13191"],["13191","13191"],["13191","13503"],["14210","13191"],["13503","13191"],["14467","13191"],["13375","13191"],["47858","13191"],["25798","13191"],["28670","28670"],["13375","28670"],["47858","28670"],["14467","29249"],["47858","29249"],["25798","29249"],["28668","13191"],["28668","13503"],["14467","28668"],["47858","28668"],["25798","28668"],["47858","28965"],["47858","43244"],["14467","13191"],["14467","29796"],["14467","14467"],["14467","13407"],["14467","13377"],["14467","13762"],["14467","29249"],["14467","28668"],["47858","14467"],["13377","13375"],["13375","13377"],["13375","28670"],["13375","13191"],["13375","14210"],["13375","13503"],["47858","13375"],["47858","13418"],["47858","25798"],["25798","13191"],["25798","29249"],["25798","28862"],["25798","28668"],["25798","14210"],["25798","25798"],["25798","13377"],["25798","13762"],["13377","14952"],["13377","14952"],["14210","13377"],["13377","13375"],["13377","13377"],["14467","13377"],["13375","13377"],["47858","13377"],["25798","13377"],["13762","28862"],["13762","13503"],["13762","13191"],["14467","13762"],["47858","13762"],["25798","13762"],["13762","28862"],["47858","28862"],["47858","28862"],["25798","28862"],["47858","45296"],["13762","13503"],["13191","13503"],["28668","13503"],["13503","13191"],["13375","13503"],["47858","13503"],["14467","29796"],["47858","29796"],["47858","34877"],["14952","14952"],["13377","14952"],["13377","14952"],["47858","14952"],["47858","34975"],["47858","33347"],["13762","28862"],["47858","28862"],["47858","28862"],["25798","28862"]]}
