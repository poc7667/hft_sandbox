module ImportDataHelper
  def get_error_log_path(rake_file)
    base_name = File.basename rake_file, ".rake"
    File.expand_path("../#{base_name}.error.log", rake_file)
  end

  def get_market_folder(market_name, rake_file)
    File.expand_path("../sample_data/#{market_name}", rake_file)
  end
end