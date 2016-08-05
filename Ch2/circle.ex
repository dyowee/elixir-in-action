defmodule Circle do
    @moduledoc "Implements basic circle functions"
    @pi 3.14159

    @doc "Computes the area of a circle"
    @spec area(number) :: number
	def area(radius), do: radius * radius * @pi
	
	@doc "Computes the circumference of a circle"
	@spec circumference(number) :: number
	def circumference(radius) do
		2 * radius * @pi
	end

end