module Banker
  module Shoulda
    def should_cache_page(description, &block)
      should "cache #{description} page" do
        cache_path = instance_eval(&block)
        assert_page_cached cache_path
      end
    end
  
    def should_expire_page(description, &block)
      should "expire #{description} page" do
        cache_path = instance_eval(&block)
        assert_page_expired cache_path
      end
    end
    
    def should_cache_action(description, action)
      should "cache #{description} action" do
        assert_action_cached(action)
      end
    end
    
    def should_expire_action(description, action)
      should "expire #{description} action" do
        assert_action_expired(action)
      end
    end
    
    def should_cache_fragment(description, key)
      should "cache #{description}" do
        assert_fragment_cached(key)
      end
    end
    
    def should_expire_fragment(description, key)
      should "expire #{description}" do
        assert_fragment_expired(key)
      end
    end
  end
end

ActiveSupport::TestCase.extend Banker::Shoulda
