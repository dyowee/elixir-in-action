defmodule TodoList do
	
    defstruct auto_id: 0,
              entries: HashDict.new
    def new(entries \\ []) do
        Enum.reduce(
            entries,
            %TodoList{},
            &add_entry(&2, &1)
        )
    end	

    def add_entry(%TodoList{entries: entries, auto_id: auto_id} = todo_list, entry) do
        new_id = auto_id + 1
        new_entry = Map.put(entry, :id, new_id)
        new_entries = HashDict.put(entries, new_id, new_entry)
        %TodoList{todo_list | entries: new_entries, auto_id: new_id}
    end

end

defmodule TodoList.CsvImporter do
    
    def import(csv_file) do
        csv_file
        |> read_lines
        |> create_entries        
        |> TodoList.new
    end
    
    defp read_lines(csv_file) do
        File.stream!(csv_file)        
        |> Stream.map(&String.replace(&1, "\n", ""))
    end

    defp create_entries(lines) do
        lines
        |> Stream.map(&extract_fields/1)
        |> Stream.map(&create_entry/1)
        |> Enum.map(fn({date, title}) -> %{date: date, title: title} end)
    end

    defp create_entry([date_string, title]) do
        date = date_string
        |> String.split("/")
        |> Enum.map(&String.to_integer(&1))
        |> List.to_tuple
        {date, title}
    end

    defp extract_fields(line) do
        line
        |> String.split(",")        
    end

end