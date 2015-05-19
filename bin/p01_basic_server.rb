require 'webrick'
server = WEBrick::HTTPServer.new(Port: 3000)

server.mount_proc("/") do |request, response|
  query = request.request_line
  response.content_type = 'text/text'

  parsed_address = query.split(' ')[1]
  # response.body = parsed_address
  response.body = response
end

trap('INT') do
  server.shutdown
end

server.start

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
