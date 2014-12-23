module SamplingHelper

  def get_contract_month_by_product_type
    ActiveRecord::Base.connection.execute(
      %{SELECT DISTINCT
        contract_month, product_type
        FROM czces;}
      )
  end

  def get_sampling_begin_time(info, frequncy)
      # if yes 
      record = CzceHft.where{"contract_month = '#{info["contract_month"]}'"}
                       .where{"product_type = '#{info["product_type"]}'"}
                       .order('time DESC').first
      unless record.nil?
        return record.time
      else
        # record = Czce.where{"contract_month = '#{info["contract_month"]}'"}
        #         .where{"product_type = '#{info["product_type"]}'"}
        #         .order('ticktime ASC').first
        # return record.time
        return Time.at(0).to_datetime
      end
  end

end

