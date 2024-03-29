def while2 (cond, &block)
    if cond.call
       block.call
       while2 cond, &block
    end
end    

def fib_up_to (max)
    i1, i2 = 0,1
    while2 proc {i1 <= max} do
    	  yield i1
	  i1, i2 = i2, i1+i2
    end
end

fib_up_to (1000) do |f| 
	  print f, " "
end

puts ""

