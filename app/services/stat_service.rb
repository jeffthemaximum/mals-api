require 'singleton'

class StatService < ApplicationService
  include Singleton
  include StatHat

  def initialize
    @stat_queue = []
  end

  def enqueue(stat_name, options = {})
    unless stat_name
      Rails.logger.error 'Stat enqueue error. Missing stat_name.'
      return
    end

    if !options[:count] && !options[:value]
      Rails.logger.error "Stat enqueue error. stat_name: #{stat_name}; options: #{options}"
      return
    end

    if options[:count]
      stat_name = "mals_api/#{Rails.env}/#{stat_name}/count"
      enqueue_count(stat_name, options[:count])
    elsif options[:value]
      stat_name = "mals_api/#{Rails.env}/#{stat_name}/value"
      enqueue_value(stat_name, options[:value])
    end
  end

  def log
    if @stat_queue.empty?
      Rails.logger.info 'Empty stat queue'
    else
      Rails.logger.info "Logging to stathat: #{@stat_queue}"
      cached_queue = @stat_queue.dup
      @stat_queue = []
      StatHat::API.ez_post_data(cached_queue, Rails.application.credentials.stathat_api_key)
    end
  end

  private

    def enqueue_count(stat_name, count)
      existing_stat = @stat_queue.detect { |stat| stat[:stat] == stat_name }
      if existing_stat
        existing_stat[:count] += count
      else
        stat = { stat: stat_name, count: count }
        @stat_queue << stat
      end
    end

    def enqueue_value(stat_name, value)
      stat = { stat: stat_name, value: value }
      @stat_queue << stat
    end
end
