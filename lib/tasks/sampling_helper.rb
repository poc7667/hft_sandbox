module SamplingHelper

  def get_contract_month_by_product_type(market)
    ActiveRecord::Base.connection.execute(
      %{SELECT DISTINCT
        contract_month, product_type
        FROM #{market};}
      )
  end

  def get_sampling_begin_time(info, frequncy)
      record = CzceHft.where{"contract_month = '#{info["contract_month"]}'"}
                       .where{"product_type = '#{info["product_type"]}'"}
                       .order('time DESC').first
      unless record.nil?
        return record.time
      else
        return Time.at(0).to_datetime
      end
  end
end
