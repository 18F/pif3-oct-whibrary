require './lib/search'

require 'sinatra/base'

class Server < Sinatra::Base

  get '/search' do
    query = Search::Query.new(params[:q])

    query.dataset.all.map { |i| i[:name] }.join(', ')
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end