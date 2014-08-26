json.array!(@datafiles) do |datafile|
  json.extract! datafile, :id, :data
  json.url datafile_url(datafile, format: :json)
end
