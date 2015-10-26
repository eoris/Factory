class Factory
  def self.new(*attributes, &block)
    Class.new do

      attributes.each do |attribute|        
        class_eval {attr_accessor attribute}
      end

      define_method :initialize do |*value|
        attributes.each_with_index {|attribute, index| instance_variable_set("@#{attribute}", value[index]) }
      end

      define_method ("[]") do |attribute|
        attribute.class == Fixnum ? instance_variable_get("@#{attributes[attribute]}") : instance_variable_get("@#{attribute}")
      end

      define_method ("[]=") do |attribute, value|
        attribute.class == Fixnum ? instance_variable_set("@#{attributes[attribute]}", value) : instance_variable_set("@#{attribute}", value)
      end

      class_eval(&block) if block_given?
    end
  end
end

Customer = Factory.new(:name, :address, :zip) do
  def greeting
    "Hello #{name}!"
  end
end

joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
joe.name
joe["name"]
joe[:name]
joe[0]
joe.greeting