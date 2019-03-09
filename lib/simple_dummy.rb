require 'yaml'

Dir.glob(File.join(File.dirname(__FILE__), 'helpers', '*.rb')).sort.each { |file| require file }
Dir.glob(File.join(File.dirname(__FILE__), 'types', 'number.rb')).sort.each { |file| require file }
Dir.glob(File.join(File.dirname(__FILE__), 'types', 'integer.rb')).sort.each { |file| require file }
Dir.glob(File.join(File.dirname(__FILE__), 'types', 'float.rb')).sort.each { |file| require file }
Dir.glob(File.join(File.dirname(__FILE__), 'types', '*.rb')).sort.each { |file| require file }

class SimpleDummy
  DEFAULT_LENGTH_OF_ASSOCIATION_COLLECTION = 5
  SIMPLE_TYPES = ["Integer", "Float", "Boolean", "String", "Time", "Date"]
  SPECIAL_TYPES = ["Array", "SingleObject"]

  ##
  # - It auto loads the structure of object in yml file
  #   Default is: klass.yml
  #   - To change the filename, use opts[:filename_with_path]
  # - If you have an association, and want to config it, please use:
  #   opts[:associations] = [
  #     {
  #       klass:
  #       length: the number of associations in the collection. #Default is DEFAULT_LENGTH_OF_ASSOCIATION_COLLECTION
  #       filename_with_path
  #     }
  #   ]
  ##
  def initialize klass, number_of_objects, opts = {}
    begin
      @klass = Kernel.const_get(klass.capitalize)
      @is_class = true
    rescue NameError => e
      @klass = klass
      @is_class = false
    end

    @number_of_objects = number_of_objects
    @opts = opts || {}
  end

  def generate
    begin
      filename = @opts[:filename_with_path] || "#{@klass}.yml"
      fields = YAML.load_file(filename)
      arr = []

      @number_of_objects.times.each do |index|
        data = generate_for_hash(fields)

        if @is_class
          arr << @klass.new(data)
        else
          arr << data
        end
      end
    rescue StandardError => e
      puts e.message
    end

    arr
  end

  private

  def generate_for_hash hash
    data = {}
    hash.each do |key, type|
      data[key] = generate_value(type)
    end

    data
  end

  def generate_for_single_object(object_info)
    ass_name = object_info["kclass"].to_s.downcase
    ass_conf = association_config(ass_name)

    SimpleDummy.new(ass_name, 1, ass_conf).generate.first
  end

  ##
  # Array of objects
  # object can be simple types or a complicate object
  ##
  def generate_for_array(object_info)
    if (object_info["kclass"].to_s.is_a?(String) && SIMPLE_TYPES.include?(object_info["kclass"]))
      arr = []
      number_of_objs = object_info["length"] || DEFAULT_LENGTH_OF_ASSOCIATION_COLLECTION

      number_of_objs.times.each do |index|
        arr << eval("SimpleDummyTypes::#{object_info['kclass'].capitalize}").random
      end

      return arr
    end

    ass_name = object_info["kclass"].to_s.downcase
    ass_conf = association_config(ass_name)

    number_of_objs = ass_conf["length"] || object_info["length"] || DEFAULT_LENGTH_OF_ASSOCIATION_COLLECTION
    SimpleDummy.new(ass_name, number_of_objs, ass_conf).generate
  end

  def generate_value type
    if (type.is_a?(String) && SIMPLE_TYPES.include?(type))
      return eval("SimpleDummyTypes::#{type.capitalize}").random
    end

    return nil unless type.is_a?(Hash)

    if type["type"] == "Hash"
      return generate_for_hash(type["keys"])
    end

    if type["type"] == "SingleObject" || type["type"] == "Array"
      send("generate_for_#{SimpleDummyHelpers::StringHelper.underscore(type['type'])}", type)
    else
      nil
    end
  end

  def association_config(association)
    associations_config[association] || {}
  end

  def associations_config
    @associations_config ||= {}
    if @associations_config.empty? && @opts[:associations].is_a?(Array) && !@opts[:associations].empty?
      @opts[:associations].each do |config|
        @associations_config[config[:klass]] = config
      end
    end

    @associations_config
  end
end
