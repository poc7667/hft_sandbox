module Queryable
  extend ActiveSupport::Concern
    # binding.pry
    # q_str = query_str(params["sample_freq"], params["begin_time"], params["end_time"], params["product_type"])
  attr_accessor :errors , :query_type , :q
  errors = []

  def get_query_result
    filter_params
    check_params
    normalize_params
    print_query_log
    ActiveRecord::Base.connection.execute(build_query)
  end

  def filter_params
    self.q = params.clone
    q.delete("controller")
    q.delete("action")
  end

  def check_params # specified has higher priority than relative
    specified = ["market", "product", "contract_month", "frequency", "start_dt", "end_dt"]
    relative = ["market", "product", "contract_month", "frequency", "event_dt", "delta_time"]
    if 0 == (specified - q.keys).count
      self.query_type = :specified
    elsif 0 == (relative - q.keys).count 
      self.query_type = :relative  
    else
      self.query_type = :none
      @errors <<  "The correct parameters should be #{specified} or #{relative}"
    end
  end

  def normalize_params
    if :relative == query_type
      delta_time = get_delta_time
      q[:start_dt] = q[:event_dt]
      q[:end_dt] = (Date.parse(q[:start_dt]) + eval(delta_time)).strftime('%Y-%m-%d %H:%M:%S')
      q.delete(:event_dt)
      q.delete(:delta_time)
    end
  end

  def print_query_log
    ap("http://localhost:3000/?"+URI::unescape(q.to_query))
  end


  def build_query
    %{
      SELECT DISTINCT ON (time)
        time, high, low, open, close, volume
        FROM #{q[:market]} WHERE product_type = '#{q[:product]}'
        AND frequence = '#{q[:frequency]}'
        AND contract_month = '#{q[:contract_month]}'
        AND time >= '#{q[:start_dt]}'
        AND time < '#{q[:end_dt]}' 
    }.gsub(/\s+/, " ").strip
  end

end
