require './lib/search.rb'

namespace :search do
  task :split do
    Docsplit.extract_text(Dir['./docs/*.[pP][dD][fF]'], output: './docs')
  end
end