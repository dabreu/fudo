# frozen_string_literal: true

require 'bcrypt'

class User
  attr_reader :id, :name, :email

  def initialize(id:, name:, email:, password:)
    @id = id
    @name = name
    @email = email
    @password_hash = BCrypt::Password.create(password)
  end

  def authenticate(password)
    BCrypt::Password.new(@password_hash) == password
  end

  def to_h
    { id: id, name: name, email: email }
  end

  def to_json(*_args)
    to_h.to_json
  end
end
