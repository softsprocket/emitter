require 'thread'

class Emitter

	def initialize
		@emissions = {}
	end


	def on (token, p, once_only=false)
		@emissions[token] ||= {}
		@emissions[token][:p] ||= []
		@emissions[token][:data] ||= []
		@emissions[token][:semaphore] ||= Mutex.new
		@emissions[token][:cv] ||= ConditionVariable.new 
		
		@emissions[token][:p].push Hash[:p => p, :o => once_only]

		@emissions[token][:thread] ||= Thread.new do
			
			@emissions[token][:active] = true
			
			while @emissions[token][:active]
				@emissions[token][:semaphore].synchronize do
					self.post_data_for token
					@emissions[token][:cv].wait @emissions[token][:semaphore]
					if @emissions[token][:active]
						self.post_data_for token
					end
				end
			end

		end

	end

	def once (token, p)
		self.on token, p, true
	end

	def emit (token, data)
		@emissions[token][:semaphore] ||= Mutex.new
		@emissions[token][:cv] ||= ConditionVariable.new 
		@emissions[token][:data] ||= []

		@emissions[token][:semaphore].synchronize do
			@emissions[token][:data].push data
			@emissions[token][:cv].signal
		end

	end

	def release (token)
		@emissions[token][:active] = false
		Thread.kill @emissions[token][:thread]
	end

	protected
	def post_data_for (token)
		@emissions[token][:p].each_index do |i|
			o = @emissions[token][:p][i][:o]
		       	p = @emissions[token][:p][i][:p]
			
			if o
				@emissions[token][:p].slice! i
			end

			if i == @emissions[token][:p].length - 1	
				while @emissions[token][:data].length > 0 do
					data = @emissions[token][:data].shift 
					p.call data
					if o 
						@emissions[token][:data] = []
						break
					end
				end
			else
				@emissions[token][:data].each do |data|
					p.call data
					if o 
						break
					end
				end
			end

		end
	end
end


