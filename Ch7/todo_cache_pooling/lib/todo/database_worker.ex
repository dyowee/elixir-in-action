defmodule Todo.DatabaseWorker do
	use GenServer
    
    def start(db_folder) do
        GenServer.start(__MODULE__, db_folder)
    end
      
    def store(pid, key, data) do
        IO.inspect pid
        GenServer.cast(pid, {:store, key, data})
    end

    def get(pid, key) do
        IO.inspect pid
        GenServer.call(pid, {:get, key})
    end

    def init(db_folder) do        
        {:ok, db_folder}
    end

    def handle_cast({:store, key, data}, db_folder) do
        file_name(db_folder, key) |> File.write!(:erlang.term_to_binary(data))

        {:noreply, db_folder}
    end
    
    def handle_call({:get, key}, _, db_folder) do
        data = case File.read(file_name(db_folder, key)) do
            {:ok, contents} -> :erlang.binary_to_term(contents)
            _ -> nil
        end    
        
        {:reply, data, db_folder}
    end

    defp file_name(folder, key), do: "#{folder}/#{key}"
end

