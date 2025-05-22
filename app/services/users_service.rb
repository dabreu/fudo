# frozen_string_literal: true

require 'singleton'
require_relative '../models/user'
require_relative '../errors/api_error'

class UsersService
  include Singleton

  def initialize
    @users = []
    @next_id = 1
  end

  def all
    @users
  end

  def create(name, email, password)
    # Check if email is already taken
    raise Errors::ValidationError, 'Email already taken' if @users.any? { |user| user.email == email }

    user = User.new(id: @next_id, name: name, email: email, password: password)
    @users << user
    @next_id += 1
    user
  end

  def find(id)
    @users.find { |u| u.id == id }
  end

  def find_by_email(email)
    @users.find { |u| u.email == email }
  end
end
