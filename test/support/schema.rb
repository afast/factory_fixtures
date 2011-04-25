ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.string :first_name
    t.string :last_name
    t.string :email
    t.string :encrypted_password
    t.string :password_salt

    t.integer :account_id
  end

  create_table :accounts, :force => true do |t|
    t.string :company
    t.boolean :is_verified
    t.string :address
    t.string :zip
  end

  create_table :cities_users, :id => false, :force => true do |t|
    t.integer :city_id
    t.integer :user_id
  end

  create_table :cities, :force => true do |t|
    t.string :name
  end

end 

