module DatetimeHelper
  extend ActiveSupport::Concern
  def get_delta_time
    quantity = q[:delta_time].scan(/\d+/).first.to_i
    time_unit =  q[:delta_time].scan(/\D+/).first.strip
    unless ["second", "minute", "hour", "day", "week", "month", "year"].include? time_unit
      @errors << "Wrong time_unit"
      return false       
    end
    return "#{quantity}.#{time_unit}"
  end
end
