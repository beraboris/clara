require 'sqlite3'

module Clara
  class Database
    def initialize(db_file)
      @db = SQLite3::Database.new db_file
      @db.results_as_hash = true

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

    def package_exists(id)
      not fetch_package(id).nil?
    end

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

    def delete_package(id)
      if @delete_package.nil?
        @delete_package = @db.prepare <<-SQL
          delete from packages where id=?;
        SQL
      end

      @db.transaction { @delete_package.execute id }
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
