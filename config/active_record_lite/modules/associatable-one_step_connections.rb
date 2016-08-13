require_relative 'searchable'
require 'active_support/inflector'
require_relative 'attr_accessor_object.rb'

require 'byebug'

class AssocOptions < AttrAccessorObject
  my_attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    "#{class_name.underscore}s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @class_name = options[:class_name] || name.to_s.camelcase
  end

end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || "#{self_class_name.underscore}_id".to_sym
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
  end
end

module Associatable
  def belongs_to(name, options = {})
    option = BelongsToOptions.new(name, options)
    define_method name  do
      fkv = self.send(option.foreign_key)
      option.model_class.where(option.primary_key.to_sym => fkv).first
    end
    assoc_options[name] = option
  end

  def has_many(name, options = {})
    option = HasManyOptions.new(name, self.to_s, options)
    define_method name do
      pkv = self.send(option.primary_key)
      option.model_class.where(option.foreign_key.to_sym => pkv)
    end
    assoc_options[name] = option
  end

  def assoc_options
    @assoc_options ||= Hash.new
  end
end
