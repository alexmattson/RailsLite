require 'active_support/inflector'
require_relative 'dependencies.rb'
require_relative 'db_connection.rb'

class SQLObject < AttrAccessorObject
  extend Searchable
  extend Associatable

  def self.columns
    return @columns if @columns
    data = DBConnection.execute2("SELECT * FROM #{self.table_name}").first
    data.map!{|x|x.to_sym}
    @columns = data
  end

  def self.finalize!
    # @id = nil
    # define_method "id" do
    #   instance_variable_get("@id")
    # end
    self.columns.each do |column|
      define_method column do
        self.attributes["#{column}".to_sym]
      end
      define_method "#{column}=" do |arg|
        self.attributes["#{column}".to_sym] = arg
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    results = DBConnection.execute("SELECT * FROM #{self.table_name}")
    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |attributes| self.new(attributes) }
  end

  def self.find(id)
    query = "SELECT * FROM #{self.table_name} WHERE id = #{id} LIMIT 1"
    results = DBConnection.execute(query)
    self.parse_all(results).first
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      attr_name = attr_name.to_sym
      unless self.class.columns.include?(attr_name) || attr_name == :id
        raise "unknown attribute '#{attr_name}'"
      else
        self.send("#{attr_name}=", val)
      end
    end
  end

  def attributes
    @attributes ||= Hash.new
  end

  def attribute_values
    self.class.columns.map{|c| self.send(c)}
  end

  def insert
    col_names = get_insert_column_names
    question_marks = (["?"] * (column_names.count)).join(", ")
    question_marks = "(#{question_marks})"
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} #{col_names}
      VALUES
        #{question_marks}
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = get_update_column_names
    DBConnection.execute(<<-SQL, *attribute_values, self.id)
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names}
      WHERE
        id = ?
    SQL
  end

  def save
    self.id.nil? ? insert : update
  end

  private
  def get_insert_column_names
    "(#{column_names.join(', ')})"
  end

  def get_update_column_names
    "#{column_names.join(" = ?, ")}  = ?"
  end

  def column_names
    col = self.class.columns
    col.reject!{|x| x == :id}
    col
  end

end
