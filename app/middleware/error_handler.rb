# frozen_string_literal: true

require_relative '../errors/api_error'

class ErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue Errors::ApiError => e
    puts "API Error: #{e.class} - #{e.status_code} - #{e.message}\n#{e.backtrace.join("\n")}"
    [
      e.status_code,
      { 'content-type' => 'application/json' },
      [{ error: e.message }.to_json]
    ]
  rescue StandardError => e
    # unexpected errors
    puts "Internal Server Error: #{e.class} - #{e.message}\n#{e.backtrace.join("\n")}"
    [
      500,
      { 'content-type' => 'application/json' },
      [{ error: 'Internal Server Error' }.to_json]
    ]
  end
end
