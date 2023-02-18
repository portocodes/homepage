require 'webrick'

server = WEBrick::HTTPServer.new Port: 3000, DocumentRoot: 'build'
server.start
