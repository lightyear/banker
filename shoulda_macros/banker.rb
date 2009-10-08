module Banker
  module Shoulda
    def should_cache_page(description, &block)
      should "cache #{description} page" do
        cache_path = instance_eval(&block)
        assert_page_cached cache_path
      end
    end
  
    def should_not_cache_page(description, &block)
      should "not cache #{description} page" do
        cache_path = instance_eval(&block)
        assert_page_not_cached cache_path
      end
    end
  
    def should_expire_page(description, &block)
      should "expire #{description} page" do
        cache_path = instance_eval(&block)
        assert_page_expired cache_path
      end
    end
    
    def should_not_expire_page(description, &block)
      should "not expire #{description} page" do
        cache_path = instance_eval(&block)
        assert_page_not_expired cache_path
      end
    end
    
    def should_cache_action(description, action)
      should "cache #{description} action" do
        assert_action_cached(action)
      end
    end
    
    def should_not_cache_action(description, action)
      should "not cache #{description} action" do
        assert_action_not_cached(action)
      end
    end
    
    def should_expire_action(description, key)
      should "expire #{description} action" do
        assert_action_expired(action)
      end
    end
    
    def should_not_expire_action(description, key)
      should "not expire #{description} action" do
        assert_action_not_expired(action)
      end
    end
    
    def should_cache_fragment(description, key)
      should "cache #{description}" do
        assert_fragment_cached(key)
      end
    end
    
    def should_not_cache_fragment(description, key)
      should "not cache #{description}" do
        assert_fragment_not_cached(key)
      end
    end
    
    def should_expire_fragment(description, key)
      should "expire #{description}" do
        assert_fragment_expired(key)
      end
    end
    
    def should_not_expire_fragment(description, key)
      should "not expire #{description}" do
        assert_fragment_not_expired(key)
      end
    end
  end
end

ActiveSupport::TestCase.extend Banker::Shoulda
