require 'em-websocket'
require 'date'


  EM.run do
    @clients = []
    EM::WebSocket.start(:host => 'localhost', :port => '3005') do |ws|
      ws.onopen do |handshake|
        @clients << ws
        ws.send "Conecting.."
      end

      ws.onclose do
        ws.send "Closed."
        @clients.delete ws
      end

      ws.onmessage do |msg|
        puts "Received Message: #{msg} #{Time.now.strftime('%d %B %Y  %H:%M:%S')}"
        @clients.each do |socket|
          socket.send msg
        end
      end
    end
  end


