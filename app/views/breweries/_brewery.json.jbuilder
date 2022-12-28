json.extract! brewery, :id, :name, :year, :created_at, :updated_at
json.url brewery_url(brewery, format: :json)

json.extract! brewery, :id, :name, :year
json.beercount brewery.beers.count
if brewery.active
  json.status "active"
else
  json.status "inactive"
end
