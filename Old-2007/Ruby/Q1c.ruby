def while2 (cond, &block)
    if cond.call
       block.call
       while2 cond, &block
    end
end

class Integer
  def times2
    i = 1
    while2 proc {i <= self} do
       yield i
       i += 1
    end
  end
end

5.times2 { |i| puts i }