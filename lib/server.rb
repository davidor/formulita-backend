require 'sinatra'

DATA_PATH = File.expand_path('../../data', __FILE__).freeze

get '/' do
  status(200)
end

get '/seasons/:year' do |year|
  content_type :json

  begin
    File.read("#{DATA_PATH}/#{year}.json")
  rescue Errno::ENOENT
    status(404)
  end
end
