# frozen_string_literal: true

require 'rack/static'

class StaticContent
  def initialize(app, options = {})
    @static = Rack::Static.new(app, options)
  end

  def call(env)
    status, headers, body = @static.call(env)

    if status == 200
      path = env['PATH_INFO']

      case path
      when %r{^/openapi\.yaml$}
        headers['cache-control'] = 'no-store'
      when %r{^/AUTHORS$}
        headers['cache-control'] = 'public, max-age=86400' # 24 hours
      end
    end

    [status, headers, body]
  end
end
