class Greeter
  def greet(message=nil)
    if message
      "Hello #{message}!"
    else
      "Hello."
    end
  end
end