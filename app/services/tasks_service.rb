# frozen_string_literal: true

require 'singleton'
require 'concurrent-ruby'
require_relative '../models/task'

class TasksService
  include Singleton

  def initialize
    @tasks = []
    @next_id = 1
    @executor = Concurrent::ThreadPoolExecutor.new(
      min_threads: 2,
      max_threads: 5,
      max_queue: 10,
      fallback_policy: :discard
    )
  end

  def run_async(action, resource, callable, callable_params)
    task = Task.new(id: @next_id, action: action, resource: resource, callable: callable,
                    callable_params: callable_params)
    @tasks << task
    @next_id += 1
    Concurrent::Future.execute(executor: @executor) do
      task.status = :running
      result = callable.call(*callable_params)
      task.result = result
      task.status = :completed
    rescue StandardError => e
      task.result = { error: e.message }
      task.status = :failed
    end
    task
  end

  def find(id)
    @tasks.find { |task| task.id == id }
  end

  def all
    @tasks
  end
end
