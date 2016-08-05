defmodule Recursion do

	def list_len(list), do: do_list_len(0, list)

	def range(l, h), do: do_range([], l, h)
    
    def positive(list), do: do_positive([], list)
    
    defp do_list_len(acc, []), do: acc

    defp do_list_len(acc, [_ | tail]), do: do_list_len(acc + 1, tail)
        
    defp do_range(acc, l, h) when l > h, do: Enum.reverse(acc)

    defp do_range(acc, l, h), do: do_range([l | acc], l + 1, h)    
    
    defp do_positive(acc, []), do: Enum.reverse(acc)

    defp do_positive(acc, [head | tail]) do
    	cond do
    		head > 0 -> do_positive([head | acc], tail)
    		true -> do_positive(acc, tail)
    	end
    end 

end