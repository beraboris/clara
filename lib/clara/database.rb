require 'sqlite3'

module Clara
  class Database
    def initialize(db_file)
      @db = SQLite3::Database.new db_file

      # self closing block
      if block_given?
        yield self
        close
      end
    end

    # Create the schema for the DB
    def create_schema
      exec_file File.expand_path '../../../sql/create_package_db.sql', __FILE__
    end

    def drop_schema
      exec_file File.expand_path '../../../sql/drop_package_db.sql', __FILE__
    end

    def close
      @db.close
    end

    private

    def exec_file(file)
      @db.transaction do |db|
        db.execute_batch File.read(file)
      end
    end
  end
end
