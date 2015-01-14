class NumberSet
  include Enumerable

  def initialize
    @numbers = []
  end

  def each
     @numbers.each {|number| yield number}
  end

  def <<(number)
    unless @numbers.include? number
      @numbers << number
    end
  end

  def size
    @numbers.size
  end

  def empty?
    size == 0
  end

  def [](filter)
    numbers = NumberSet.new

    @numbers.each do |number|
      if filter.check.call number
        numbers << number
      end
    end

    numbers
  end
end

class Filter

  attr_accessor :check

  def initialize(&check)
    @check = check
  end
end

class TypeFilter < Filter

  def initialize(type)
    case type
      when :integer  then @check = integer
      when :real     then @check = real
      when :complex  then @check = complex
    end
  end

  def integer
    lambda {|number| number.class == Fixnum}
  end

  def real
    lambda {|number| number.class == Float || number.class == Rational}
  end

  def complex
    lambda {|number| number.class == Complex}
  end
end

class SignFilter < Filter

  def initialize(sign)
    case sign
      when :positive     then  @check = positive
      when :non_positive then  @check = non_positive
      when :negative     then  @check = negative
      when :non_negative then  @check = non_negative
    end
  end

  def positive
    lambda {|number| number > 0}
  end

  def non_positive
    lambda {|number| number <= 0}
  end

  def negative
    lambda {|number| number < 0}
  end

  def non_negative
    lambda {|number| number >= 0}
  end
end