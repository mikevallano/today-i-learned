json.array!(@reflections) do |reflection|
  json.extract! reflection, :id, :title, :body, :user_id
  json.url reflection_url(reflection, format: :json)
end
