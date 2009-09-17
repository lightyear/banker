require 'action_controller'

module Banker
  class TestStore < ActiveSupport::Cache::Store
    def initialize
      super
      reset_test_state
    end
  
    def reset_test_state
      @data = {}
      @written = {}
      @expired = {}
    end
  
    def read(key, options = nil)
      @data[key] if key_written?(key)
    end
  
    def write(key, value, options = nil)
      @data[key] = value
      @written[key] = Time.now
    end
  
    def delete(key, options = nil)
      @data.delete(key)
      @expired[key] = Time.now
    end
  
    def delete_matched(matcher, options = nil)
      @data.keys.grep(matcher).each { |key| delete(key) }
    end

    def exist?(key, options = nil)
      key_written?(key)
    end
  
    def key_written?(key)
      @written[key] && (!@expired[key] || (@written[key] > @expired[key]))
    end
  
    def key_expired?(key)
      @expired[key] && (!@written[key] || (@expired[key] > @written[key]))
    end
  end

  module TestPageCacheStore
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        cattr_accessor :pages_cached
        cattr_accessor :pages_expired
      end
    end

    module ClassMethods
      def expire_page(path)
        return unless perform_caching
        logger.debug "Expired page: #{page_cache_file(path)}"
        pages_expired[path] = Time.now
      end

      def page_expired?(path)
        pages_expired.include?(path)
      end

      def cache_page(content, path)
        return unless perform_caching
        logger.debug "Cached page: #{page_cache_file(path)}"
        pages_cached[path] = Time.now
      end

      def page_cached?(path)
        pages_cached.include?(path)
      end
    end
  end
end

ActionController::Base.class_eval do
  include Banker::TestPageCacheStore
end
