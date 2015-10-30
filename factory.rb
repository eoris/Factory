class Factory
  def self.new(*attributes, &block)
    class_name = attributes.shift.capitalize if attributes.first.is_a?(String)
    class_name_from_string = Class.new do
      attributes.each do |attribute|
        attr_accessor attribute
      end

      define_method :initialize do |*value|
        attributes.each_with_index do |attribute, index|
          instance_variable_set("@#{attribute}", value[index])
        end
      end

      define_method '[]' do |attribute|
        if attribute.class == Fixnum
          instance_variable_get("@#{attributes[attribute]}")
        else
          instance_variable_get("@#{attribute}")
        end
      end

      define_method '[]=' do |attribute, value|
        if attribute.class == Fixnum
          instance_variable_set("@#{attributes[attribute]}", value)
        else
          instance_variable_set("@#{attribute}", value)
        end
      end

      define_method :each do |&attribute_value|
        values.each(&attribute_value)
      end

      # define_method :each_pair do |&attribute|
      #   joe.each_pair {|name, value| puts("#{name} => #{value}") }
      # end

      # define_method :eql? do
      # end

      # define_method :hash do
      # end

      # define_method :inspect do
      # end

      # define_method :length do
      # end

      # define_method :members do
      # end

      # define_method :select do
      # end

      # define_method :size do
      # end

      define_method :to_a do
        instance_variables.map { |i| instance_variable_get(i) }
      end
      alias_method :values, :to_a

      # define_method :to_h do
      # end

      # define_method :to_s do
      # end

      # define_method :values do
      # end

      # define_method :values_at do
      # end

      class_eval(&block) if block_given?
    end
    const_set(class_name, class_name_from_string) if class_name
    class_name_from_string
  end
end

Customer = Factory.new(:name, :address, :zip) do
  def greeting
    "Hello #{name}!"
  end
end

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
joe.name
joe['name']
joe[:name]
joe[0]
joe.greeting

Factory.new('Customer', :name, :address, :zip)
joe.each { |i| puts i }
#joe.each_pair {|name, value| puts("#{name} => #{value}") }