require 'sqlite3'

PRINT_QUERIES = 'true'
ROOT_FOLDER = File.join(File.dirname(__FILE__)).gsub("/config/active_record_lite", "")
DB_ROUTE = File.join(ROOT_FOLDER, 'db/')
DATABASE_SQL_FILE = File.join(DB_ROUTE, 'database.sql')
DATABASE_DB_FILE = File.join(DB_ROUTE, 'database.db')


class DBConnection
  def self.open(db_file_name)
    if db_file_name.include?(DB_ROUTE)
      @db = SQLite3::Database.new(db_file_name)
    else
      @db = SQLite3::Database.new("#{DB_ROUTE}" + db_file_name)
    end
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = [
      "rm '#{DATABASE_DB_FILE}'",
      "cat '#{DATABASE_SQL_FILE}' | sqlite3 '#{DATABASE_DB_FILE}'"
    ]
    commands.each { |command| %x(#{command}) }
    DBConnection.open(DATABASE_DB_FILE)
  end

  def self.instance
    reset if @db.nil?
    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
