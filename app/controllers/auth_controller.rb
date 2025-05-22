# frozen_string_literal: true

require 'json'
require_relative '../services/auth_service'
require_relative '../utils/validation'
require_relative '../errors/api_error'

module Controllers
  class AuthController
    def self.login(req)
      data = begin
        JSON.parse(req.body.read)
      rescue StandardError
        {}
      end

      # Validate required fields
      errors = Validation.required_fields(data, %w[email password])
      raise Errors::ValidationError, errors.to_json unless errors.empty?

      token = AuthService.instance.authenticate(data['email'], data['password'])
      raise Errors::UnauthorizedError, 'Invalid email or password' if token.nil?

      [200, {}, [{ token: token }.to_json]]
    end
  end
end
