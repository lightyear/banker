if Rails.env.test?
  require 'banker/test_case'
end

require 'banker/conditional_cache'
