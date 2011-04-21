class User < ActiveRecord::Base

  belongs_to :account
end

class Account < ActiveRecord::Base

  has_many :users
end

