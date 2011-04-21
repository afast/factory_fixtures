define :verified_account do |a|
  a.is_verified true
  a.address { |a| "#{rand 100} - #{a.company}" }
  a.zip { "#{rand 10}" * 5 }
end


create :test_poc, :verified_account do
  company 'test_poc'
end

