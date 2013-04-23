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

    def insert_package(name, bundle, version, author)
      # prepare statement if needed
      if @insert_package.nil?
        @insert_package = @db.prepare <<-SQL
          insert into packages(name, bundle, version, author)
          values (:name, :bundle, :version, :author);
        SQL
      end

      package_id = nil
      @db.transaction do |db|
        @insert_package.execute(name: name, bundle: bundle, version: version, author: author)
        package_id = db.last_insert_row_id
      end
      package_id
    end

    # Create the schema for the DB
    def create_schema
      exec_file File.expand_path '../../../sql/create_package_db.sql', __FILE__
    end

    def drop_schema
      exec_file File.expand_path '../../../sql/drop_package_db.sql', __FILE__
    end

    def close
      # close all prepared statements
      @insert_package.close unless @insert_package.nil?

      @db.close
    end

    def closed?
      @db.closed?
    end

    private

    def exec_file(file)
      @db.transaction do |db|
        db.execute_batch File.read(file)
      end
    end
  end
end
