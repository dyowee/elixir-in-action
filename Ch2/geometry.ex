defmodule Geometry do

	def rectangle_area(length, width) do
		length * width
	end

	def square_area(side) do
		rectangle_area(side, side)
	end
end