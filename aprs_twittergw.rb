require 'socket'
require 'rubygems'
require 'twitter'

##Having problems with a ssl errors in windows? https://gist.github.com/fnichol/867550

class Aprs
  def initialize(server, port, call)
    @server  = server
    @port    = port
	@call = call
  end
  
  def connect
	@socket = TCPSocket.open(@server, @port)
	@socket.puts "#{@server} #{@port}"
	pass = self.passcode(@call.upcase)
	@socket.puts "user #{@call.upcase} pass #{pass} ver \"Twitter_Gateway\""
  end
  
  
    def msg_loop()
		until @socket.eof? do
		msg = @socket.gets
		self.msg_dis(msg)
	 	end
    end

  
  def msg_dis(msg)
	Thread.new do
	msg.gsub!(/>.*::/, "->").gsub!(/\s.*:/, ": ")
	puts self.send_msg(msg) if msg =~ /#{@call.upcase}/ 
		end
   end

   def send_msg(msg)
		msg.gsub!(/TWIT.*R/, "")
		puts "Debug(Sending to Twitter): #{msg}"
		$client.update("#{msg}")
    end
  
  def packet(position, comment)
	init = "#{@call.upcase}>APRS,TCPIP*:"
	send = "#{init}#{position} #{comment}"
	puts "Debug(Outgoing): #{send}"
	@socket.puts "#{send}"
  end
  
  def passcode(call_sign) ## credit to https://github.com/xles/aprs-passcode/blob/master/aprs_passcode.rb
	call_sign.upcase!
	call_sign.slice!(0,call_sign.index('-')) if call_sign =~ /-/
	hash = 0x73e2
	flag = true
	call_sign.split('').each{|c|
	hash = if flag
	(hash ^ (c.ord << 8))
		else
		(hash ^ c.ord)
		end
	flag = !flag
	}
	hash & 0x7fff
   end
  
  
end
  
  $client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "your_key_here"
  config.consumer_secret     = "your_key_here"
  config.access_token        = "your_key_here"
  config.access_token_secret = "your_key_here"
end

  
  aprs = Aprs.new("second.aprs.net", 20157, "your_callsign_here")
  aprs.connect
  aprs.packet("=4158.19N/08556.81W-", "Twitter Gateway YOUR MSG HERE")
  aprs.msg_loop
  