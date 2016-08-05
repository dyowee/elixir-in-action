defmodule MyModule do
   import Circle

   def run do
      IO.puts "Circle area: #{area(10)}"	
   end

end

MyModule.run
