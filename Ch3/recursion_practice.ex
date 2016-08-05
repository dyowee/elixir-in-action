defmodule Recursion do
	
	def list_len([]), do: 0
	       
    def list_len([_ | tail]), do: 1 + list_len(tail)    

    def range(l, h) do
    	if l <= h do
    		[l | range(l + 1, h)]
    	else
    		[]
    	end
    end

    def positive([]), do: []    	
    
    def positive([head | tail]) do
    	cond do
    		head > 0 -> [head | positive(tail)]
    		true -> positive(tail)
    	end
    end    
end