module Banker
  module Assertions
    def path_for_page(*args)
      options = args.extract_options!
      case args.first
      when Symbol
        path = @controller.url_for({
          :controller => @controller.controller_name,
          :action => args.first,
          :only_path => true }.reverse_merge!(options))
      when String
        path = args.first
        path = $1 if path =~ %r{^https?://[^/]+(/[^\?]*)}
      when Hash
        path = @controller.url_for(args.first.merge(:only_path => true))
      end
      
      path
    end
    
    def assert_page_cached(*args)
      path = path_for_page(*args)
      assert ActionController::Base.page_cached?(path), "#{path} is not cached"
    end
  
    def assert_page_not_cached(*args)
      path = path_for_page(*args)
      assert !ActionController::Base.page_cached?(path), "#{path} is cached, but should be expired"
    end
  
    def assert_page_expired(*args)
      path = path_for_page(*args)
      assert ActionController::Base.page_expired?(path), "#{path} is not expired"
    end
  
    def assert_page_not_expired(*args)
      path = path_for_page(*args)
      assert !ActionController::Base.page_expired?(path), "#{path} is expired, but should be cached"
    end
    
    #------------------------------------------------------------------------
    
    def key_for_action(action)
      path = ActionController::Caching::Actions::ActionCachePath.path_for(@controller, { :action => action }, false)
      ActiveSupport::Cache.expand_cache_key(path, :views)
    end
    
    def assert_action_cached(action)
      key = key_for_action(action)
      assert ActionController::Base.cache_store.key_written?(key), "#{action} action is not cached"
    end
    
    def assert_action_not_cached(action)
      key = key_for_action(action)
      assert !ActionController::Base.cache_store.key_written?(key), "#{action} action is cached, but should be expired"
    end
    
    def assert_action_expired(action)
      key = key_for_action(action)
      assert ActionController::Base.cache_store.key_expired?(key), "#{action} action is not expired"
    end
    
    def assert_action_not_expired(action)
      key = key_for_action(action)
      assert !ActionController::Base.cache_store.key_expired?(key), "#{action} action is expired, but should be cached"
    end
    
    #------------------------------------------------------------------------
    
    def assert_fragment_cached(name = {})
      key = @controller.fragment_cache_key(name)
      assert ActionController::Base.cache_store.key_written?(key), "fragment #{key} is not cached"
    end
    
    def assert_fragment_not_cached(name = {})
      key = @controller.fragment_cache_key(name)
      assert !ActionController::Base.cache_store.key_written?(key), "fragment #{key} is cached, but should be expired"
    end

    def assert_fragment_expired(name = {})
      key = @controller.fragment_cache_key(name)
      assert ActionController::Base.cache_store.key_expired?(key), "fragment #{key} is not expired"
    end
    
    def assert_fragment_not_expired(name = {})
      key = @controller.fragment_cache_key(name)
      assert !ActionController::Base.cache_store.key_expired?(key), "fragment #{key} is expired, but should be cached"
    end
  end
end
