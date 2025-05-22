# frozen_string_literal: true

class JsonContentTypeMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    # Call the next middleware or application
    status, headers, body = @app.call(env)

    # Ensure the Content-Type is set to application/json
    headers['content-type'] ||= 'application/json'

    [status, headers, body]
  end
end
