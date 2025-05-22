# frozen_string_literal: true

class Task
  attr_reader :id, :action, :resource, :status, :result
  attr_accessor :status, :result

  def initialize(id:, action:, resource:, callable:, callable_params:)
    @id = id
    @action = action
    @resource = resource
    @status = :pending
    @callable = callable
    @callable_params = callable_params
    @result = nil
  end

  def to_h
    {
      task_id: id,
      task_action: action,
      task_resource: resource,
      task_status: status,
      task_result: result
    }
  end

  def to_json(*_args)
    to_h.to_json
  end
end
