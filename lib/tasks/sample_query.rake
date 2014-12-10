desc "Sample query"
namespace :sample do
  task :query => :environment do
    ap("sample query")
    raw_q = 'SELECT cast(ticktime as timestamp(1)) AS ticktime
              ,max(bid_price) as price, max(bid_volume) as volume
              From  czces
              Group BY 1
              ORDER BY 1
              limit 1000;'
    def sampe_query
      ActiveRecord::Base.connection.select_all(raw_q)
    end

    # results = ActiveRecord::Base.connection.execute(raw_q)
    # r2 =
    # binding.pry
    result = Czce.where("ticktime > ? ", "2014-02-09".to_datetime).raw_query
    binding.pry

    ap("finished")
  end
end