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

defmodule TodoServer do
	def init do
        TodoList.new   
    end

    def start do
        ServerProcess.start(TodoServer)
    end
   
    def add_entry(todo_server, new_entry) do
        ServerProcess.cast(todo_server, {:add_entry, new_entry})    
    end
    
    def update_entry(todo_server, entry_id, updater_fn) do
        ServerProcess.cast(todo_server, {:update_entry, entry_id, updater_fn})    
    end
    
    def update_entry(todo_server, %{} = entry) do
        update_entry(todo_server, entry.id, fn(_) -> entry end)    
    end

    def delete_entry(todo_server, entry_id) do
        ServerProcess.cast(todo_server, {:delete_entry, entry_id})    
    end

    def entries(todo_server, date) do
        ServerProcess.call(todo_server, {:entries, date})            
    end   

    def handle_cast({:add_entry, entry}, todo_list) do 
        TodoList.add_entry(todo_list, entry)
    end
    
    def handle_cast({:update_entry, entry_id, updater_fn}, todo_list) do 
        TodoList.update_entry(todo_list, entry_id, updater_fn)
    end

    def handle_cast({:delete_entry, entry_id}, todo_list) do 
        TodoList.delete_entry(todo_list, entry_id)
    end

    def handle_call({:entries, date}, todo_list) do 
        {TodoList.entries(todo_list, date), todo_list}
    end
end

defmodule TodoList do
	
	defstruct auto_id: 1,
	          entries: HashDict.new

	def new, do: %TodoList{}	

    def add_entry(%TodoList{auto_id: auto_id, entries: entries} = todo_list, entry) do
    	new_entry = Map.put(entry, :id, auto_id)
    	new_entries = HashDict.put(entries, auto_id, new_entry)
    	%TodoList{todo_list | entries: new_entries, auto_id: auto_id + 1}
    end
    
    def update_entry(%TodoList{entries: entries} = todo_list, entry_id, updater_fn) do
        case entries[entry_id] do
            nil -> todo_list
            old_entry ->
                new_entry = %{id: ^entry_id} = updater_fn.(old_entry)
                new_entries = HashDict.put(entries, entry_id, new_entry)
                %TodoList{todo_list | entries: new_entries}
        end    
    end

    def delete_entry(%TodoList{entries: entries} = todo_list, entry_id) do
        %TodoList{todo_list | entries: HashDict.delete(entries, entry_id)}
    end

    def entries(%TodoList{entries: entries}, date) do
    	entries
    	|> Stream.filter(fn({_, entry}) ->
    	      entry.date == date
    	   end)
    	|> Enum.map(fn({_, entry}) ->
    	      entry
    	   end)
    end
end