if Node.connect(:foo@localhost) == true do
	:rpc.call(:foo@localhost, :init, :stop, [])
	IO.puts "Node terminated"
else
	IO.puts "Cannot connect to remote node"
end