defmodule TodoList do
	
	defstruct auto_id: 1,
	          entries: HashDict.new

	def new, do: %TodoList{}		
    
    def add_entry(%TodoList{entries: entries, auto_id: auto_id} = todo_list, entry) do
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
    
    def update_entry(todo_list, %{} = new_entry) do
        update_entry(todo_list, new_entry.id, fn(_) -> new_entry end)
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