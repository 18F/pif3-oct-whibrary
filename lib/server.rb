require './lib/search'

require 'sinatra/base'

class Server < Sinatra::Base

  get '/search' do
    query = Search::Query.new(params[:q])

    results = query.dataset.all

    # binding.pry

    reduced = results.reduce({}) do |memo, item|
      doctype = item[:doctype]

      if memo[doctype]
        memo[doctype] << item
      else
        memo[doctype] = [item]
      end

      memo
    end

    erb :search, locals: {query: query, results: results, q: params[:q], reduced: reduced}
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end