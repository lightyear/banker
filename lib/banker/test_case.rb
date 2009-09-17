require 'active_support/test_case'
require 'banker/assertions'
require 'banker/test_store'

ActionController::Base.cache_store = Banker::TestStore.new

class ActiveSupport::TestCase
  include Banker::Assertions

  setup :reset_cache_store

  def reset_cache_store
    ActionController::Base.cache_store.reset_test_state
    ActionController::Base.pages_cached = {}
    ActionController::Base.pages_expired = {}
  end
end
