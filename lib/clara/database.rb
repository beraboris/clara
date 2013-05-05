require 'sqlite3'

module Clara
  ##
  # Handles all database interactions.
  class Database

    ##
    # Opens the sqlite db found at the +db_file+ path, if the db doesn't exist, a new one will be created
    #
    # if a block is provided, the block will be executed and the db will be closed at the end of the block
    def initialize(db_file)
      @db = SQLite3::Database.new db_file
      @db.results_as_hash = true

      # self closing block
      if block_given?
        yield self
        close
      end
    end

    ##
    # Stores a package to the database
    #
    # +name+, +bundle+, +version+, and +author+ are all strings
    # the timestamp is also automatically inserted (default value in SQL)
    #
    # @return the id of the inserted row
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

    ##
    # @return a row for the package as a hash. The keys of the hash are strings and not symbols (I blame SQLite3)
    def fetch_package(id)
      if @fetch_package.nil?
        @fetch_package = @db.prepare <<-SQL
          select id, name, bundle, version, author, strftime('%s',installed_on) as installed_on
          from packages where id=?
        SQL
      end

      res = @fetch_package.execute(id).next_hash
      res['installed_on'] = Time.at(res['installed_on'].to_i) unless res.nil?
      res
    end

    ##
    # Checks whether or not a package is present in the DB
    # @return true if present, false otherwise
    def package_exists(id)
      not fetch_package(id).nil?
    end

    ##
    # Updates the package in the db with the matching +id+
    #
    # <em>All fields are required. the whole row is updated at once</em>
    def update_package(id, name, bundle, version, author, installed_on)
      # prepared statement if needed
      if @update_package.nil?
        @update_package = @db.prepare <<-SQL
          update packages set
            name = :name,
            bundle = :bundle,
            version = :version,
            author = :author,
            installed_on = datetime(:installed_on, 'unixepoch')
          where id = :id
        SQL
      end

      @db.transaction do
        @update_package.execute id: id, name: name, bundle: bundle, version: version,
                                author: author, installed_on: installed_on.to_i
      end
    end

    # deletes a package with the matching +id+
    def delete_package(id)
      if @delete_package.nil?
        @delete_package = @db.prepare <<-SQL
          delete from packages where id=?;
        SQL
      end

      @db.transaction { @delete_package.execute id }
    end

    ##
    # Create the schema of the DB
    #
    # This method reads the file sql/create_package_db.sql and executes it
    def create_schema
      exec_file File.expand_path '../../../sql/create_package_db.sql', __FILE__
    end

    ##
    # Drops the schema of the DB
    #
    # This method reads the file sql/drop_package_db.sql and executes it
    def drop_schema
      exec_file File.expand_path '../../../sql/drop_package_db.sql', __FILE__
    end

    # close the db connection
    def close
      # close all prepared statements
      [
        :@insert_package,
        :@fetch_package,
        :@update_package,
        :@delete_package
      ].each {|s| instance_variable_get(s).close if instance_variable_defined? s}

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
