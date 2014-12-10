以下 Model 的定義就是 database 裡面 table 的意思

#  Model: DataSource

## Scheme

TODO: index , mar

	class DataSource < ActiveRecord::Base {
	                  :id => :integer,
	              :market => :string,
	        :product_type => :string,
	    :transaction_date => :datetime,
	           :file_name => :string,
	             :md5_sum => :text,
	             :comment => :string,
	          :created_at => :datetime,
	          :updated_at => :datetime
	}

