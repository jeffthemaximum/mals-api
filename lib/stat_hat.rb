require 'httparty'
require 'cgi'
require 'uri'
require 'json'
require 'thread'
require 'singleton'

module StatHat
	class Common
		EZ_URL = "https://api.stathat.com/ez"

		class << self
      def send_to_stathat(url, args)
        body = { ezkey: args[:ezkey], data: args[:data] }
        res = HTTParty.post(
          url,
          :body => body.to_json,
          :headers => { 'Content-Type' => 'application/json' }
        )
			end
		end
	end

	class SyncAPI
		class << self
			def ez_post_data(data, ezkey)
				args = {
					:data => data,
					:ezkey => ezkey
				}
				Common::send_to_stathat(Common::EZ_URL, args)
      end
		end
	end

	class API
    class << self
      def ez_post_data(data, ezkey, &block)
        Reporter.instance.ez_post_data(data, ezkey, block)
      end
		end
	end

	class Reporter
		include Singleton

		def initialize
			@que = Queue.new
			@runlock = Mutex.new
			run_pool()
		end

		def finish()
			stop_pool
		end

    def ez_post_data(data, ezkey, cb)
      args = {
        :data => data,
        :ezkey => ezkey
      }
      enqueue(Common::EZ_URL, args, cb)
    end

		private
		def run_pool
			@runlock.synchronize { @running = true }
			@pool = []
			5.times do |i|
				@pool[i] = Thread.new do
					while true do
						point = @que.pop
						begin
							resp = Common::send_to_stathat(point[:url], point[:args])
							if point[:cb]
								point[:cb].call(resp)
							end
						rescue
							pp $!
						end
						@runlock.synchronize {
							break unless @running
						}
					end
				end
			end
		end

		def stop_pool()
			@runlock.synchronize {
				@running = false
			}
			@pool.each do |th|
				th.join if th && th.alive?
			end
		end

		def enqueue(url, args, cb=nil)
			return false unless @running
			point = {:url => url, :args => args, :cb => cb}
			@que << point
			true
		end
	end
end
