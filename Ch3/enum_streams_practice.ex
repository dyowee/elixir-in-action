defmodule StreamsP do

	def lines_lengths!(path) do
       filtered_lines!(path) 
       |> Enum.map(&String.length(&1)) 
    end	
    
    def longest_line_length!(path) do
       filtered_lines!(path) 
       |> Stream.map(&String.length/1)       
       |> Enum.max
    end
    
    def longest_line!(path) do
       filtered_lines!(path)       
       |> Enum.reduce("", fn(el, acc) ->
             if String.length(el) > String.length(acc) do
                 el
             else
                acc
             end
          end
       )
    end
    
    def words_per_line!(path) do
       filtered_lines!(path)       
       |> Enum.map(&word_count/1) 
    end

    defp filtered_lines!(path) do
       File.stream!(path)
       |> Stream.map(&String.replace(&1, "\n", ""))  
    end

    defp word_count(line) do
        line
        |> String.split(" ")
        |> Enum.filter(&(String.strip(&1) != ""))
        |> length
    end
end