module AttributesParser

  def get_contract_month(raw_data)
    numbers = raw_data.scan( /\d+/ )
    if 1 == numbers.count
      raw_target_month = numbers.first
      return "201#{raw_target_month[0]}/#{raw_target_month[1..-1]}/01".to_datetime
    else
      return false
    end
  end

  def get_tick_date(year_month, month_day)
    return apply_china_timezone("#{year_month}#{month_day[2..-1]}".to_datetime)
  end

  def apply_china_timezone(dt)
    dt.change(:offset => "+0800")
  end

  def get_ticktime(date, time)
    apply_china_timezone(DateTime.parse(date.strftime('%Y-%m-%dT') + time))
  end

  def get_finer_time(time)
    time.strftime('%Y-%m-%d %H:%M:%S.%N')
  end

end