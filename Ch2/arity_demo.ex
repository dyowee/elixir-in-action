defmodule Rectangle do

	def area(length, width), do: length * width

	def area(side), do: area(side, side)
	
end