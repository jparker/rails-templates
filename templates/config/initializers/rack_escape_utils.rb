# http://openhood.com/rack/ruby/2010/07/15/rack-test-warning/
require 'escape_utils/html/rack'
require 'escape_utils/html/haml'

module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end
