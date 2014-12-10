module CountByInterval
  def count_by_interval(aggregate_range = 'day', column = "#{self.table_name}.created_at", aggregate_operation = 'count(*)')
    aggregate_on = "date_trunc('#{aggregate_range}', #{column})"
    self.select_values = ["coalesce(#{aggregate_operation}, 0) as value", "#{aggregate_on} as date"]
    ActiveRecord::Base.connection.execute(self.group(aggregate_on).to_sql).collect {|r| r}
  end
end

ActiveRecord::Relation.send(:include, CountByInterval) #EWWWWwww

# results = ActiveRecord::Base.connection.execute(query);