class NumberSet
  include Enumerable

  def initialize
    @numbers = []
  end

  def each(&block)
     @numbers.each(&block)
  end

  def <<(number)
    @numbers << number unless @numbers.include? number
  end

  def size
    @numbers.size
  end

  def empty?
    @numbers.empty?
  end

  def [](filter)
    filtered = NumberSet.new

    each do |number|
      filtered << number if filter.block.call number
    end

    filtered
  end
end

class Filter

  attr_accessor :block

  def initialize(&block)
    @block = block
  end

  def &(other)
    Filter.new {|x| block.call x and other.block.call x}
  end

  def |(other)
    Filter.new {|x| block.call x or other.block.call x}
  end
end

class TypeFilter < Filter
  def initialize(type)
    case type
    when :integer  then super() {|x| x.is_a? Integer}
    when :real     then super() {|x| x.is_a? Float or x.is_a? Rational}
    when :complex  then super() {|x| x.is_a? Complex}
    end
  end
end

class SignFilter < Filter
  def initialize(sign)
    case sign
    when :positive     then super() {|x| x > 0}
    when :non_positive then super() {|x| x <= 0}
    when :negative     then super() {|x| x < 0}
    when :non_negative then super() {|x| x >= 0}
    end
  end
end