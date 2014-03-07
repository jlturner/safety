module SafetyAttributeHelper
  def self.parse_attribute_type method
    if method.to_s =~ /attr_accessor_[a-zA-Z_]*/
      :accessor 
    elsif method.to_s =~ /attr_reader_[a-zA-Z_]*/
      :reader
    elsif method.to_s =~ /attr_writer_[a-zA-Z_]*/
      :writer
    else
      nil
    end
  end
end