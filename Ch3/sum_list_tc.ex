defmodule ListHelper do
	
	def sum(list), do: do_sum(0, list)
    
    defp do_sum(sum, []), do: sum
   
    defp do_sum(sum, [head | tail]) do
    	new_sum = sum + head
    	do_sum(new_sum, tail)
    end

end