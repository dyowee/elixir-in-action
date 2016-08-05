defmodule TestPrivate do
	
	def double(a), do: sum(a, a)

    defp sum(a, b) do
    	a + b
    end
end

defmodule TestImport do
	import IO

	def write(str) do
		puts(str)	
	end

end

defmodule TestAlias do
	alias IO, as: InputOutput

	def write(str), do: InputOutput.puts(str)
end