class StatsJob < ApplicationJob
  after_perform do |job|
    self.class.set(:wait => 10.seconds).perform_later
  end

  def perform
    StatService.instance.log
  end
end
