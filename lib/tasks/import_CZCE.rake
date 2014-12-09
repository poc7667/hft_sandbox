desc "Import cheng zhou commedies exchange"
namespace :import do
  task :czce => :environment do
    require File.expand_path('attributes_parser', File.dirname(__FILE__))
    include AttributesParser

    def import_to_db(im_file_path, tick_date, product_type, contract_month)
      File.open(im_file_path,'r').each_with_index do |row, i|
        next if 0==i
        fields = row.strip!.split(',')
        ticktime = get_ticktime(tick_date, fields[0])
        get_finer_time(ticktime)
        binding.pry
        ap(transaction)

      end
      Czce.create(
        )
    #               :id => :integer,
    #     :product_type => :string,
    #         :ticktime => :datetime,
    #            :float => :string,
    #      :last_volume => :float,
    # :last_total_price => :float,
    #        :bid_price => :float,
    #       :bid_volume => :float,
    #        :ask_price => :float,
    #       :ask_volume => :float,
    #    :open_interest => :float,
    #     :trade_volume => :float,
    #       :created_at => :datetime,
    #       :updated_at => :datetime,
    #   :contract_month => :datetime
    end

    folder = File.expand_path("../sample_data/CZCE", __FILE__)
    Dir["#{folder}/**/*.txt"].each do |im_file_path|
      toks = im_file_path.split('/')
      contract_month = get_contract_month(toks.last)
      tick_date = get_tick_date(toks[-4], toks[-2])
      product_type = toks[-3]
      import_to_db(im_file_path, tick_date, product_type, contract_month)
      ap(tick_date)
      binding.pry
      next
      # [11] "CZCE",
      # [12] "201402",
      # [13] "CF",
      # [14] "0207",
      # [15] "CF405.txt"
    end

  end
end