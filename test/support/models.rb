class User < ActiveRecord::Base

  belongs_to :account
  has_and_belongs_to_many :cities
end

class Account < ActiveRecord::Base

  has_many :users
end

class City < ActiveRecord::Base

  has_and_belongs_to_many :users
end
