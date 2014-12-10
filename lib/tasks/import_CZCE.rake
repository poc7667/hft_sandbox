desc "Import cheng zhou commedies exchange"
namespace :import do
  task :czce => :environment do
    require File.expand_path('attributes_parser', File.dirname(__FILE__))
    require File.expand_path('import_data_helper', File.dirname(__FILE__))
    include AttributesParser
    include ImportDataHelper

    # Czce.destroy_all
    # ActiveRecord::Base.connection.reset_pk_sequence!(:czces)

    def import_to_db(im_file_path, tick_date, product_type, contract_month)
      File.open(im_file_path,'r').each_with_index do |row, i|
        next if 0==i
        fields = row.strip!.split(',')
        ticktime = get_ticktime(tick_date, fields[0])
        czce = Czce.create(
          product_type: product_type,
          contract_month: contract_month,
          ticktime: ticktime,
          last_price: fields[1].to_f,
          last_volume: fields[2].to_f,
          bid_price: fields[3].to_f,
          bid_volume: fields[4].to_f,
          ask_price: fields[5].to_f,
          ask_volume: fields[6].to_f,
          open_interest: fields[7].to_f,
          trade_volume:fields[8].to_f,
        )
        czce.last_total_price = czce.last_price * czce.last_volume
        czce.save
      end
        # [
        #     [0] "09:00:08.0",
        #     [1] "19565.0",
        #     [2] "0.0",
        #     [3] "19255.0",
        #     [4] "1.0",
        #     [5] "20020.0",
        #     [6] "1.0",
        #     [7] "34.0",
        #     [8] "0.0"
        # ]
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

    File.open(get_error_log_path(__FILE__),'w') do |error_log|
      Dir["#{get_market_folder("CZCE", __FILE__)}/**/*.txt"].each_with_index do |im_file_path, i|
        begin
          toks = im_file_path.split('/')
          contract_month = get_contract_month(toks.last)
          tick_date = get_tick_date(toks[-4], toks[-2])
          product_type = toks[-3]

          DataSource.create(
            market: "czce",
            product_type:  product_type,
            transaction_date: tick_date,
            file_name: File.basename(im_file_path, ".txt"),
            md5_sum: Digest::MD5.file(im_file_path).hexdigest
          )
          binding.pry

          # import_to_db(im_file_path, tick_date, product_type, contract_month)
        rescue Exception => e
          error_log.puts "File: #{im_file_path} \nError: #{e}\n"
          next
        end
        p "#{i}:#{im_file_path}\n"
      end
    end

  end
end