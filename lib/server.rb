require './lib/search'

require 'sinatra/base'

class Server < Sinatra::Base

  get '/search' do
    query = Search::Query.new(params[:q])

    results = query.dataset.all

    erb :search, locals: {query: query, results: results, q: params[:q]}
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end