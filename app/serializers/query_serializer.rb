class QuerySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :query_content
end
