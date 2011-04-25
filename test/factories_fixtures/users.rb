
define :with_default_password do |u|
  u.encrypted_password '$2a$10$xMfCF.PExnD59a5F3hBV1eKTi6t3YZAUw7y0VspO3Z.sx.xgl9kcG'
  u.password_salt '$2a$10$xMfCF.PExnD59a5F3hBV1e'
  u.email { |u| "#{u.first_name}@example.org" }
end


create :smith, :with_default_password do
  first_name 'smith'
  last_name 'richardson'
  account_id F(:test_poc)
end

create :john do
  first_name 'john'
  last_name 'jameson'
  account F(:test_poc)
end

create :akira do
  first_name 'Akira'
  cities F(:tokyo), F(:kyoto)
end
