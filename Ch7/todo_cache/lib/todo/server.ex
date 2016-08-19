defmodule Todo.Server do
	use GenServer
    
    def start do
        GenServer.start(Todo.Server, nil)
    end
   
    def add_entry(todo_server, new_entry) do
        GenServer.cast(todo_server, {:add_entry, new_entry})    
    end
    
    def update_entry(todo_server, entry_id, updater_fn) do
        GenServer.cast(todo_server, {:update_entry, entry_id, updater_fn})    
    end
    
    def update_entry(todo_server, %{} = entry) do
        update_entry(todo_server, entry.id, fn(_) -> entry end)    
    end

    def delete_entry(todo_server, entry_id) do
        GenServer.cast(todo_server, {:delete_entry, entry_id})    
    end

    def entries(todo_server, date) do
        GenServer.call(todo_server, {:entries, date})            
    end   

    def init(_) do
        {:ok, Todo.List.new}
    end

    def handle_cast({:add_entry, entry}, todo_list) do 
        {:noreply, Todo.List.add_entry(todo_list, entry)}
    end
    
    def handle_cast({:update_entry, entry_id, updater_fn}, todo_list) do 
        {:noreply, Todo.List.update_entry(todo_list, entry_id, updater_fn)}
    end

    def handle_cast({:delete_entry, entry_id}, todo_list) do 
        {:noreply, Todo.List.delete_entry(todo_list, entry_id)}
    end

    def handle_call({:entries, date}, _, todo_list) do 
        {:reply, Todo.List.entries(todo_list, date), todo_list}
    end
end

