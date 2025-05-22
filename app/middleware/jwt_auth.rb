# frozen_string_literal: true

require 'jwt'
require_relative '../errors/api_error'

class JwtAuth
  def initialize(app)
    @app = app
    @exclusions = [
      { method: 'POST', path: '/api/users' },
      { method: 'POST', path: '/api/login' }
    ]
  end

  def call(env)
    req = Rack::Request.new(env)

    # Skip authentication for excluded paths/methods
    return @app.call(env) if excluded?(req)

    # Get the token from the Authorization header
    token = extract_token(req)
    raise Errors::UnauthorizedError, 'Missing token' unless token

    begin
      user = AuthService.instance.validate_token(token)
      raise Errors::UnauthorizedError, 'Invalid token' unless user

      # to be used by the controllers (in case that the logged user is needed)
      env['authenticated_user'] = user
    rescue JWT::DecodeError
      raise Errors::UnauthorizedError, 'Invalid token'
    end

    @app.call(env)
  end

  private

  def excluded?(req)
    @exclusions.any? do |rule|
      rule[:method] == req.request_method && rule[:path] == req.path
    end
  end

  def extract_token(req)
    auth_header = req.env['HTTP_AUTHORIZATION']
    return nil unless auth_header&.start_with?('Bearer ')

    auth_header.split(' ').last
  end
end
