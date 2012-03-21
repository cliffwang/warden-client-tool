$:.unshift(File.dirname(__FILE__))
require "client"


class Container
  @@client = nil

  def self.client(client)
    if client.is_a?(String)
      @@client = Warden::Client.new(client)
    else
      @@client = client
    end
  end

  def initialize ()
    req = [ "create", { "bind_mounts" => [[ "/media", "/store", { "mode" => "rw" } ]] } ]
    @handle = @@client.call(req)
    puts "handle is a String: #{@handle}" if @handle.is_a? String
  end

  def stop()
    req = [ "stop", @handle ]
    @@client.write(req)
  end

  def info()
    req = [ "info", @handle ]
    rsp = @@client.call(req)
  end

  def run(cmd)
    req = [ "run", @handle, cmd ]
    rsp = @@client.call(req)
  end

  def spawn(cmd)
    req = [ "spawn", @handle, cmd ]
    rsp = @@client.call(req)
  end

  def netinfo()
    req = [ "net", @handle, "in" ]
    rsp = @@client.call(req)
  end
end

client = Warden::Client.new("/tmp/warden.sock")
client.connect
Container.client(client)
ct = Container.new()
puts ct.info
puts ct.netinfo
puts "***********************"
#puts ct.run("df -h;ifconfig;route;ls /")
#puts.ct.run("ifconfig")
#puts.ct.run("route")
#puts.ct.run("ls /")
#job = ct.spawn("mongod -f /etc/mongod.conf")

while input = gets
  input.chop!
  if input == "quit"
    break
  elsif input == "" || input.nil?
    next
  end
  puts ct.run(input)
end
#ct.stop
