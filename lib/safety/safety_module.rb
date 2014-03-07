require 'safety/safety_attribute_helper'
module SafetyModule
  def respond_to?(method)
    if SafetyAttributeHelper.parse_attribute_type method
      true
    else
      super
    end
  end
  
  def method_missing(method, *args, &block)
    type = SafetyAttributeHelper.parse_attribute_type method
    if type
      # Extract the type name from the attribute declaration
      type_name = method.to_s.slice("attr_#{type.to_s}_".length...method.to_s.length)
      
      # If the type name is var, type safety will be disabled for this attribute
      should_enforce_type_safety = type_name != 'var'
      
      # The class to enforce type safety on
      type_safe_class = nil
      
      # Get the type, which could be deep in modules
      if should_enforce_type_safety == true
        type_safe_class = type_name.split('::').inject(Object.class) do |current_module, class_name|
          current_module.const_get(class_name)
        end
      end

      # Define enforce safety for this property
      define_method "__enforce_safety_#{args[0]}".to_sym do |value|
        # If enforcing type and value is not of type safe class, raise TypeError
        if should_enforce_type_safety == true and value.is_a?(type_safe_class) == false
          raise TypeError, "Type Safe Attribute \"#{args[0]}\", of type \"#{type_safe_class}\", set to value \"#{value}\" of class \"#{value.class}\"."
        end
        return value
      end

      # A way to get the default value
      define_method "__default_value_#{args[0]}".to_sym do
        if args[1] != nil
          return args[1]
        else
          return nil
        end
      end
      
      # Set default, if one was provided
      #set_value.call(args[1]) if args[1] != nil
      define_method "__lazy_instantiator_#{args[0]}".to_sym do
        return block
      end

      lazy_instantiation = <<EVAL
def __lazy_instantiation_#{args[0]}
  return nil if __lazy_instantiator_#{args[0]}().nil?
  instance_exec &__lazy_instantiator_#{args[0]}
end
EVAL

      getter = <<EVAL
def #{args[0]}
  @#{args[0]} = __lazy_instantiation_#{args[0]} if @#{args[0]}.nil? && __lazy_instantiator_#{args[0]} != nil
  @#{args[0]} = __enforce_safety_#{args[0]}(__default_value_#{args[0]}) if @#{args[0]}.nil? && __default_value_#{args[0]} != nil
  __enforce_safety_#{args[0]}(@#{args[0]})
end
EVAL

      setter = <<EVAL
def #{args[0]}= value
  @#{args[0]} = __enforce_safety_#{args[0]}(value)
end
EVAL

      to_evaluate = lazy_instantiation
      case type
      when :accessor
        to_evaluate << getter
        to_evaluate << setter
      when :reader
        to_evaluate << getter
      when :writer
        to_evaluate << setter
      end
      
      self.class_eval to_evaluate
    else
      super
    end
  end
end