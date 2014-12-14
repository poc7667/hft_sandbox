desc "Import cheng zhou commedies exchange"
namespace :sampling do
  task :czce => :environment do
    require File.expand_path('date_aggregate', File.dirname(__FILE__))
    include DateAggregate

    # get target_month
    get_contract_month_by_product_type.each do |t|
      binding.pry
      p t
    end

    q_str = query_by_interval('minute', '2014-02-07 01:00:00', '2014-02-07 01:01:00')
    p q_str
    res = Czce.where{product_type == 'SR' }
          .where{ticktime >=  '2014-02-07 01:00:00'}
          .where{ticktime < '2014-02-07 01:01:00'}
          .where{ contract_month == '2014-09-01 00:00:00' }

    last_volume = 0
    res.each do |row|
      last_volume += row[:last_volume].to_i
      # ap(row)
    end
    # res.each do |row|
    #   ap(row)
    # end
    binding.pry
    ActiveRecord::Base.connection.execute(q_str).each do |row|
      binding.pry
      p row

    end
    binding.pry
    p q_str


  end
end