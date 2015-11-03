class Factory
  def self.new(*attributes, &block)
    class_name_from_string = attributes.shift.capitalize if attributes.first.is_a?(String)
    class_name = Class.new do
      attributes.each do |attribute|
        attr_accessor attribute
      end

      define_method :initialize do |*value|
        attributes.each_with_index do |attribute, index|
          instance_variable_set("@#{attribute}", value[index])
        end
      end

      define_method :[] do |attribute|
        if attribute.class == Fixnum
          instance_variable_get("@#{attributes[attribute]}")
        else
          instance_variable_get("@#{attribute}")
        end
      end

      define_method :[]= do |attribute, value|
        if attribute.class == Fixnum
          instance_variable_set("@#{attributes[attribute]}", value)
        else
          instance_variable_set("@#{attribute}", value)
        end
      end

      define_method :each do |&value|
        values.each(&value)
      end

      define_method :each_pair do |&name_value|
        hash.each_pair(&name_value)
      end

      define_method :eql? do |other|
        hash.eql?(other.hash)
      end
      alias_method :==, :eql?

      define_method :hash do
        Hash[instance_variables.map { |name| [name.to_s.delete('@').to_sym, instance_variable_get(name)] }]
      end
      alias_method :to_h, :hash

      define_method :length do
        values.size
      end
      alias_method :size, :length

      define_method :members do
        instance_variables.map { |member| member.to_s.delete('@').to_sym }
      end

      define_method :select do |&member_value|
        values.select(&member_value)
      end

      define_method :to_a do
        instance_variables.map { |i| instance_variable_get(i) }
      end
      alias_method :values,  :to_a

      define_method :inspect do
        super().delete('@')
      end
      alias_method :to_s, :inspect

      define_method :values_at do |*index|
        values.values_at(*index)
      end

      class_eval(&block) if block_given?
    end
    const_set(class_name_from_string, class_name) if class_name_from_string
    class_name
  end
end

Customer = Factory.new(:name, :address, :zip) do
  def greeting
    "Hello #{name}!"
  end
end

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
jon = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
joe.name
joe['name']
joe[:name]
joe[0]
joe.greeting

Factory.new('Customer', :name, :address, :zip)

# each
joe.each { |i| puts i }

# each_pair
joe.each_pair {|name, value| puts("#{name} => #{value}") }

# hash
joe.hash

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
jon = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
# eql?
joe.eql?(jon)
# ==
joe == jon

joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
jon = Customer.new('Joe Smith', '123 Maple, Anytown NC', 1234)
# eql?
joe.eql?(jon)
# ==
joe == jon

# length
joe.length
# size
joe.size

# members
joe.members

# select
Lots = Factory.new(:a, :b, :c, :d, :e, :f)
l = Lots.new(11, 22, 33, 44, 55, 66)
l.select {|v| (v % 2).zero? } #=> [22, 44, 66]

# to_h
joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
joe.to_h[:address]   #=> "123 Maple, Anytown NC"

# to_a
joe.to_a
# values
joe.values

# inspect
joe.to_s

# to_s
joe.to_s

# values_at
joe.values_at(0, 1)
