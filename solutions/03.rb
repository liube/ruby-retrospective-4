module RBFS
  class Parser
    def initialize(string_data)
      @string_data = string_data
    end

    def parse_entities
      entities_count, @string_data = @string_data.split(':', 2)
      entities_count.to_i.times do
        name, length, rest = @string_data.split(':', 3)
        yield name, rest[0...length.to_i]
        @string_data = rest[length.to_i..-1]
      end
    end
  end

  class File

    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    def data_type
      case @data
      when NilClass              then :nil
      when String                then :string
      when Symbol                then :symbol
      when Integer, Float        then :number
      when TrueClass, FalseClass then :boolean
      end
    end

    def serialize
      "#{data_type}:#{data}"
    end

    def self.parse(string_data)
      data_type, data = string_data.split(':', 2)
      data = case data_type
             when 'string'  then data
             when 'symbol'  then data.to_sym
             when 'number'  then data.to_f
             when 'boolean' then data == 'true'
             end
      File.new(data)
    end
  end

  class Directory

    attr_reader :files, :directories

    def initialize()
      @files = {}
      @directories = {}
    end

    def add_file(name, file)
      @files[name] = file
    end

    def add_directory(name, directory = Directory.new)
      @directories[name] = directory
    end

    def [](name)
      directories[name] || files[name]
    end

    def serialize
      "#{serialize_entities(files)}#{serialize_entities(directories)}"
    end

    def self.parse(string_data)
      directory = Directory.new
      parser = Parser.new(string_data)

      parser.parse_entities do |name, data|
        directory.add_file(name, File.parse(data))
      end
      parser.parse_entities do |name, data|
        directory.add_directory(name, parse(data))
      end

      directory
    end

    private

    def serialize_entities(entities)
      serialized_entities = entities.map do |name, content|
        serialized_content = content.serialize
        "#{name}:#{serialized_content.length}:#{serialized_content}"
      end
      "#{entities.count}:#{serialized_entities.join('')}"
    end
  end
end