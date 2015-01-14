def generic_series(nth, first_value, second_value)
  return first_value if nth == 1
  return second_value if nth == 2

  generic_series(nth - 1, first_value, second_value) +
  generic_series(nth - 2, first_value, second_value)
end

def series(sequence_type, nth)
  case sequence_type
  when 'fibonacci' then generic_series(nth, 1, 1)
  when 'lucas'     then generic_series(nth, 2, 1)
  when 'summed'    then generic_series(nth, 1, 1) + generic_series(nth, 2, 1)
  end
end