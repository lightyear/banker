require 'action_view/helpers/cache_helper'

module ActionView::Helpers::CacheHelper
  def conditionally_cache(expression, *args, &block)
    if expression
      cache(*args, &block)
    else
      concat(capture(&block))
    end
  end
end
