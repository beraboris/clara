require 'rspec'
require 'sqlite3'
require 'clara'

module DBHelper
  def each_table_from_sqlite_master
    SQLite3::Database.new DB_NAME do |db|
      q = db.prepare "SELECT * FROM sqlite_master WHERE type='table' AND name=?;"
      TABLES.each do |table|
        yield q.execute(table).next
      end
      q.close
    end
  end
end

describe 'Database' do
  include DBHelper

  before :all do
    # set the db name
    DB_NAME = 'clara_test_db.sqlite'

    # define table names
    TABLES = %w{
      packages
      files
    }
  end

  after :all do
    # get rid of the test DB
    File.delete DB_NAME
  end

  before :each, clean_db: true do
    # clean up the db
    Clara::Database.new DB_NAME do |db|
      db.drop_schema
      db.create_schema
    end

    # db instance
    @db = Clara::Database.new DB_NAME
  end

  after :each, clean_db: true do
    # Aint nobody got time for that!
    @db.close
  end

  it 'creates a database' do
    db = Clara::Database.new DB_NAME
    db.close

    File.exists?(DB_NAME).should be_true
  end

  it 'creates a database schema' do
    Clara::Database.new DB_NAME do |db|
      db.create_schema
    end

    # check if the tables exist
    each_table_from_sqlite_master { |t| t.should_not be_nil }
  end

  it 'drops the database schema', clean_db: true do
    @db.drop_schema

    # check if the tables exist
    each_table_from_sqlite_master { |t| t.should be_nil }
  end

end
