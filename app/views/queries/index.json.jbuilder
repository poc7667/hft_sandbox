json.array!(@queries) do |query|
  json.extract! query, :id, :user_id, :query_content
  json.url query_url(query, format: :json)
end
