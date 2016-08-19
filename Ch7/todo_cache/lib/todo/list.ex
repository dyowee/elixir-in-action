defmodule Todo.List do
	
	defstruct auto_id: 1,
	          entries: HashDict.new

	def new, do: %Todo.List{}	

    def add_entry(%Todo.List{auto_id: auto_id, entries: entries} = todo_list, entry) do
    	new_entry = Map.put(entry, :id, auto_id)
    	new_entries = HashDict.put(entries, auto_id, new_entry)
    	%Todo.List{todo_list | entries: new_entries, auto_id: auto_id + 1}
    end
    
    def update_entry(%Todo.List{entries: entries} = todo_list, entry_id, updater_fn) do
        case entries[entry_id] do
            nil -> todo_list
            old_entry ->
                new_entry = %{id: ^entry_id} = updater_fn.(old_entry)
                new_entries = HashDict.put(entries, entry_id, new_entry)
                %Todo.List{todo_list | entries: new_entries}
        end    
    end

    def delete_entry(%Todo.List{entries: entries} = todo_list, entry_id) do
        %Todo.List{todo_list | entries: HashDict.delete(entries, entry_id)}
    end

    def entries(%Todo.List{entries: entries}, date) do
    	entries
    	|> Stream.filter(fn({_, entry}) ->
    	      entry.date == date
    	   end)
    	|> Enum.map(fn({_, entry}) ->
    	      entry
    	   end)
    end
end