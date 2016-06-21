json.array!(@languages) do |language|
  json.extract! language, :id, :message, :foreign_language
  json.url language_url(language, format: :json)
end
