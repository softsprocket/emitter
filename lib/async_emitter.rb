require 'thread'

####################################################################################
# The AsyncEmitter class provides a mechanism for asyncronous communication
# in Ruby programs. Each instantiation provides notification of events
# registered using any object that is valid as a Hash key. Multiple
# events can be registered for each key and listeners can be registered 
# for one or many events. Listeners for a key event can be released.
#
# @example
#	emitter = AsyncEmitter.new
#	emitter.on :error, lambda { |e| puts "Error: #{e}" }
#	emitter.on :data, lambda { |data| puts "Data: #{data}" }
#
#	begin
#		data = get_data_from_somewhere
#		emitter.emit :data, data
#	rescue Exception => e
#		emitter.emit :error, e
#	end
#
# Where more then one listener is registered for an event they are
# notified in the order they are recieved.
#
# @author Greg Martin
####################################################################################

class AsyncEmitter
	def initialize
		@emissions = {}
	end

	########################################################################
	# Register for notification
	#
	# @param token [Object] any valid Hash key representing the event
	# @param p [Proc] a procedure to be called on notification
	# @param once_only [Boolean] defualts to false,  if true the notification 
	# 	is removed after being fired once
	# ######################################################################
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

	########################################################################
	# Register for single notification - convenience and self documenting
	# method  for: on token, proc, true
	#
	# @param token [Object] any valid Hash key representing the event
	# @param p [Proc] a procedure to be called on notification
	# ######################################################################
	def once (token, p)
		self.on token, p, true
	end


	#######################################################################
	# Send notification of an event
	#
	# @param token [Object] the Hash key representing the event
	# @param data [Object] argument to be passed to the events procedure
	# #####################################################################
	def emit (token, data)
		@emissions[token][:semaphore] ||= Mutex.new
		@emissions[token][:cv] ||= ConditionVariable.new 
		@emissions[token][:data] ||= []

		@emissions[token][:semaphore].synchronize do
			@emissions[token][:data].push data
			@emissions[token][:cv].signal
		end

	end


	########################################################################
	# Remove notification for an event
	#
	# @param token [Object] Hash key representing the event
	########################################################################
	def release (token)
		@emissions[token][:active] = false
		Thread.kill @emissions[token][:thread]
	end

	########################################################################
	# Remove all notifications
	########################################################################
	def release_all 
		@emissions.each do |key, value|
			value[:active] = false
			Thread.kill value[:thread]
		end
	end

	protected
	def post_data_for (token)
		@emissions[token][:p].each_index do |i|
			o = @emissions[token][:p][i][:o]
		       	p = @emissions[token][:p][i][:p]
			
			if o
				@emissions[token][:p].slice! i
			end

			if i >= @emissions[token][:p].length - 1	
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


