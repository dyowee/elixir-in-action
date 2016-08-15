defmodule TodoServer do
	
    def start do
        Process.register(spawn(fn -> loop(TodoList.new) end), :todo_server)
    end
   
    def add_entry(new_entry) do
        send(:todo_server, {:add_entry, new_entry})    
    end
    
    def update_entry(entry_id, updater_fn) do
        send(:todo_server, {:update_entry, entry_id, updater_fn})    
    end
    
    def update_entry(%{} = entry) do
        update_entry(entry.id, fn(_) -> entry end)    
    end

    def delete_entry(entry_id) do
        send(:todo_server, {:delete_entry, entry_id})    
    end

    def entries(date) do
        send(:todo_server, {:entries, self, date})
        receive do
            {:entries, entries} -> entries
            after 5000 -> {:error, :timeout}
        end      
    end

    defp loop(todo_list) do
        new_todo_list = receive do
            message ->
                process_message(todo_list, message)
        end

        loop(new_todo_list)
    end

    defp process_message(todo_list, {:add_entry, entry}) do 
        TodoList.add_entry(todo_list, entry)
    end
    
    defp process_message(todo_list, {:update_entry, entry_id, updater_fn}) do 
        TodoList.update_entry(todo_list, entry_id, updater_fn)
    end

    defp process_message(todo_list, {:delete_entry, entry_id}) do 
        TodoList.delete_entry(todo_list, entry_id)
    end

    defp process_message(todo_list, {:entries, caller, date}) do 
        send(caller, {:entries, TodoList.entries(todo_list, date)})
        todo_list        
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