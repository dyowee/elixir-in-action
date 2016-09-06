defmodule Todo.Server do
	use GenServer
    
    def start_link(name) do
        IO.puts "Starting to-do server for #{name}."        
        GenServer.start_link(__MODULE__, name, name: via_tuple(name))
    end
    
    def whereis(name) do
        Todo.ProcessRegistry.whereis_name({:todo_server, name})    
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

    def init(name) do
        {:ok, {name, Todo.Database.get(name) || Todo.List.new}}
    end

    def handle_cast({:add_entry, entry}, {name, todo_list}) do
        Todo.List.add_entry(todo_list, entry) 
        |> handle_store(name)       
    end
    
    def handle_cast({:update_entry, entry_id, updater_fn}, {name, todo_list}) do 
        Todo.List.update_entry(todo_list, entry_id, updater_fn) 
        |> handle_store(name)
    end

    def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do 
        Todo.List.delete_entry(todo_list, entry_id)
        |> handle_store(name)
    end

    def handle_call({:entries, date}, _, {name, todo_list}) do 
        {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
    end

    defp handle_store(todo_list, name) do
        Todo.Database.store(name, todo_list)
        {:noreply, {name, todo_list}}
    end

    defp via_tuple(name) do
        {:via, Todo.ProcessRegistry, {:todo_server, name}}
    end
end

