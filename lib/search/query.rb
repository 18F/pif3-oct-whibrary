module Search
  class Query
    attr_reader :dataset

    def initialize(input)
      @dataset = DB[:docs].where("terms @@ ?", Sequel.function(:plainto_tsquery, 'english', input)).order(:doctype)
    end
  end
end