defmodule Todo.Database do
	use GenServer
    
    def start_link(db_folder) do
        IO.puts "Starting database server"
        GenServer.start_link(__MODULE__, db_folder, name: :database_server)
    end
      
    def store(key, data) do
        GenServer.call(:database_server, {:get_worker, key})
        |> Todo.DatabaseWorker.store(key, data)
    end

    def get(key) do
        GenServer.call(:database_server, {:get_worker, key})
        |> Todo.DatabaseWorker.get(key)
    end

    def init(db_folder) do
        File.mkdir_p(db_folder)

        {:ok, start_workers(db_folder)}
    end
    
    def handle_call({:get_worker, key}, _, workers) do
        worker = HashDict.get(workers, :erlang.phash2(key, 3))

        {:reply, worker, workers}
    end

    defp start_workers(db_folder) do
        for index <- 1..3, into: HashDict.new do
            {:ok, pid} = Todo.DatabaseWorker.start_link(db_folder)
            {index - 1, pid}
        end
    end
end

