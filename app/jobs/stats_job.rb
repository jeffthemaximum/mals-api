class StatsJob < ApplicationJob
  def perform
    StatService.instance.log
  end
end
