defmodule ServerProcess do
	
	def start(callback_module) do
		spawn(fn ->
			initial_state = callback_module.init
			loop(callback_module, initial_state)
		end)
	end

    def call(server_pid, request) do
    	send(server_pid, {:call, request, self})
    	receive do
    		{:response, response} -> response
    	end
    end
    
    def cast(server_pid, request) do
    	send(server_pid, {:cast, request})    	
    end

	defp loop(callback_module, current_state) do		
		new_state = receive do
			{:call, request, caller} ->
				{response, new_state} = callback_module.handle_call(
					request,
					current_state
				)	

				send(caller, {:response, response})
				new_state
			{:cast, request} ->
				new_state = callback_module.handle_cast(
					request,
					current_state
				)	
				
				new_state
		end

		loop(callback_module, new_state)
	end
end

defmodule KeyValueStore do
	use GenServer

	def init(_) do
		{:ok, HashDict.new}
	end
        
	def handle_cast({:put, key, value}, state) do
		{:noreply, HashDict.put(state, key, value)}
	end

	def handle_call({:get, key}, _, state) do
		{:reply, HashDict.get(state, key), state}
	end

	def start, do: GenServer.start(KeyValueStore, nil)	    
    
    def get(pid, key), do: GenServer.call(pid, {:get, key})
    
    def put(pid, key, value), do: GenServer.cast(pid, {:put, key, value})
end