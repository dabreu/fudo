# frozen_string_literal: true

module Controllers
  class TasksController
    def self.all(_req)
      tasks = TasksService.instance.all
      [200, {}, [tasks.to_json]]
    end

    def self.get(req)
      task_id = req.path_info.split('/')[3].to_i
      task = TasksService.instance.find(task_id)
      raise Errors::NotFoundError, "Task with id #{task_id} not found" unless task

      if task.status == :completed
        [303, { 'location' => "/api/#{task.resource}s/#{task.result.id}" }, [task.to_json]]
      else
        [200, {}, [task.to_json]]
      end
    end
  end
end
