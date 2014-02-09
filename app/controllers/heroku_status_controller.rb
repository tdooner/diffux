class HerokuStatusController < ApplicationController
  def queue
    render json: {
      queue: Sidekiq::Queue.new.size,
      workers: Sidekiq::Workers.new.size,
    }
  end
end
