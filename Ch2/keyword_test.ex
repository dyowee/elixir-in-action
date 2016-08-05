defmodule KeywordTest do
	
	def my_float_to_string(value), do: Float.to_string(value)
    
    def my_float_to_string(value, decimals: x), do: Float.to_string(value, decimals: x)
    
    def my_float_to_string(value, decimals: x, compact: y), do: Float.to_string(value, decimals: x, compact: y)
end