def fibonacci(number)
  if number <= 2 then 1
  else fibonacci(number - 1) + fibonacci(number - 2)
  end
end

def lucas(number)
  case number
    when 1 then 2
    when 2 then 1
    else lucas(number - 1) + lucas(number - 2)
  end
end

def series(sequence_type, number)
  case sequence_type
    when 'fibonacci' then fibonacci(number)
    when 'lucas'     then lucas(number)
    when 'summed'    then fibonacci(number) + lucas(number)
  end
end