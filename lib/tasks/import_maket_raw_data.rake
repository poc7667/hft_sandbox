desc "Import cheng zhou commedies exchange"
namespace :import do
  task :market => :environment do
    require File.expand_path('attributes_parser', File.dirname(__FILE__))
    require File.expand_path('import_data_helper', File.dirname(__FILE__))
    include AttributesParser
    include ImportDataHelper

    def import_to_db(market_table_name, im_file_path, tick_date, product_type, contract_month)
      File.open(im_file_path,'r').each_with_index do |row, i|
        next if 0==i
        fields = row.strip!.split(',')
        ticktime = get_ticktime(tick_date, fields[0])
        tick_data = market_table_name.constantize.create(
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
        tick_data.last_total_price = tick_data.last_price * tick_data.last_volume
        tick_data.save
      end
    end

    def read_market_raw_data(error_log_path, attributes)
      # Dir["#{get_market_folder("#{attributes[:folder]}", __FILE__)}/**/*.txt"].each_with_index do |im_file_path, i|
      get_market_data_from_folder(attributes[:folder]).each_with_index do |im_file_path, i|
        begin
          toks = im_file_path.split('/')
          contract_month = get_contract_month(toks.last)
          tick_date = get_tick_date(toks[-4], toks[-2])
          product_type = toks[-3]
          DataSource.create(
            market: attributes[:market],
            product_type:  product_type,
            transaction_date: tick_date,
            file_name: File.basename(im_file_path, ".txt"),
            md5_sum: Digest::MD5.file(im_file_path).hexdigest
          )
          import_to_db(attributes[:tbl_name], im_file_path, tick_date, product_type, contract_month)
        rescue Exception => e
          error_msg = "File: #{im_file_path} \nError: #{e}\n"
          ap(error_msg)
          error_log_path.puts(error_msg)
          next
        end
        p "#{i}:#{im_file_path}\n"
      end
    end

    File.open(get_error_log_path(__FILE__),'w') do |error_log_path|
      get_market_attributes.each do |attributes|
        read_market_raw_data(error_log_path, attributes)
      end
    end

  end
end