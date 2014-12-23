module ImportDataHelper
  def get_error_log_path(rake_file)
    base_name = File.basename rake_file, ".rake"
    File.expand_path("../#{base_name}.error.log", rake_file)
  end

  def get_market_folder(market_name, rake_file)
    File.expand_path("../sample_data/#{market_name}", rake_file)
  end

  def get_market_data_from_folder(marker_folder)
    Dir["#{get_market_folder("#{marker_folder}", __FILE__)}/**/*.txt"]    
  end

  def get_market_attributes
    [
      {
        folder: "CFFEX",
        market: "cffex",
        psql_tbl: "cffexes",
        tbl_name: "Cffex"
      },
      # {
      #   folder: "CZCE",
      #   market: "czce",
      #   psql_tbl: "czces",
      #   tbl_name: "Czce"
      # }
    ]
  end
end