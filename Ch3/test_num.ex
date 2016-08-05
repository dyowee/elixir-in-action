defmodule TestNum do
	
	def test(x) when is_number(x) and x < 0, do: :negative
    
    def test(x) when is_number(x) and x > 0, do: :positive
    
    def test(0), do: :zero
end