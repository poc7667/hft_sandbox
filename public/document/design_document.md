以下 Model 的定義就是 database 裡面 table 的意思

# Model: CZCE
## Introuduction

- 存放 CZCE 市場的資訊
![](http://i.imgur.com/MuUlAZK.png)


- 避免資料數量過多， overflow 造成異常 Change column 'id' from int to bigint

#  Model: DataSource

## Introduction

- 替每一個讀入的 data source 算出一個 md5sum , 以避免有重複的 data source 存入資料庫

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



