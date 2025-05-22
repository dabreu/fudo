# frozen_string_literal: true

require 'singleton'
require 'jwt'
require_relative '../services/users_service'

class AuthService
  include Singleton

  def authenticate(email, password)
    user = UsersService.instance.find_by_email(email)
    return nil unless user

    return nil unless user.authenticate(password)

    generate_token(user)
  end

  def validate_token(token)
    payload = JWT.decode(token, JWT_SECRET, true, { algorithm: 'HS256' }).first
    user = UsersService.instance.find(payload['user_id'])
    user if user
  rescue JWT::DecodeError
    nil
  end

  private

  def generate_token(user)
    payload = {
      user_id: user.id,
      exp: (Time.now + 3600).to_i # 1 hour expiration
    }

    JWT.encode(payload, JWT_SECRET, 'HS256')
  end
end
