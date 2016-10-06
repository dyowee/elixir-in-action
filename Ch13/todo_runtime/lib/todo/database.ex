defmodule Todo.Database do	    
    @pool_size 3

    def start_link(db_folder) do        
        Todo.PoolSupervisor.start_link(db_folder, @pool_size)
    end
    
    def store(key, data) do
        {results, bad_nodes} = 
            :rpc.multicall(
                __MODULE__, :store_local, [key, data],
                :timer.seconds(5)
            )

        Enum.each(bad_nodes, &IO.puts("Store failed on node #{&1}"))
        :ok
    end

    def store_local(key, data) do
        get_worker(key)
        |> Todo.DatabaseWorker.store(key, data)
    end

    def get(key) do
        get_worker(key)
        |> Todo.DatabaseWorker.get(key)
    end    

    defp get_worker(key) do
        :erlang.phash2(key, @pool_size) + 1
    end
end

