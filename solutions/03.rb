module RBFS

class File

  attr_accessor :data

  def initialize(data = nil)
    @data = data
  end

  def data_type
    case @data
    when nil                   then :nil
    when String                then :string
    when Symbol                then :symbol
    when Integer, Float        then :number
    when TrueClass, FalseClass then :boolean
    end
  end

  def serialize
    "#{data_type}:#{data}"
  end

  def File.parse(string_data)
    data_type, data = string_data.split(":")
    case data_type
    when "nil"     then File.new
    when "string"  then File.new(data)
    when "symbol"  then File.new(:"#{data}")
    when "number"  then create_file_object_with_int_or_float_data_value(data)
    when "boolean" then create_file_object_with_data_value_true_or_false(data)
    end
  end

  def File.create_file_object_with_int_or_float_data_value(data)
    (data.include? ".") ? File.new(data.to_f) : File.new(data.to_i)
  end

  def File.create_file_object_with_data_value_true_or_false(data)
    data == "true"      ? File.new(true)      : File.new(false)
  end
end

class Directory

  def initialize(files = {}, directories = {})
    @files = files
    @directories = directories
  end

  def add_file(name, file)
    @files[name] = file
  end

  def add_directory(name, directory = nil)
    @directories[name] = directory ? directory : Directory.new
  end

  def [](name)
    directories[name] ? directories[name] : files[name]
  end

  def serialize
  end

  def Directory.parse(string_data)
  end

  def files
    @files
  end

  def directories
    @directories
  end
end
end