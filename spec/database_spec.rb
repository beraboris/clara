require 'rspec'
require 'sqlite3'
require 'clara'

module DBHelper
  def each_table_from_sqlite_master
    SQLite3::Database.new DB_NAME do |db|
      q = db.prepare "SELECT * FROM sqlite_master WHERE type='table' AND name=?;"
      TABLES.each do |table|
        yield q.execute(table).any?
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
    @db.close unless @db.closed?
  end

  before :each, pkg_data: true do
    @package_fixtures = [
        {name: 'pkg_001', bundle: 'home', author: 'John Smith', version: '1.0.2'},
        {name: 'pkg_002', bundle: 'home', author: 'John Smith', version: '1.0.3'},
        {name: 'pkg_003', bundle: 'home', author: 'Johny',      version: '1.0.4'},
        {name: 'pkg_002', bundle: 'work', author: 'John Smith', version: '1.0.6'}
    ]

    @package_fixtures.each { |f| @db.insert_package f[:name], f[:bundle], f[:version], f[:author] }
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
    each_table_from_sqlite_master { |t| t.should be_true }
  end

  it 'drops the database schema', clean_db: true do
    @db.drop_schema

    # check if the tables exist
    each_table_from_sqlite_master { |t| t.should be_false }
  end

  it 'inserts packages', clean_db: true do
    package_id = @db.insert_package 'package', 'bundle', '0.0.0', 'author'

    # prevent conflict
    @db.close

    # check if it's in the db
    db = SQLite3::Database.new DB_NAME
    db.results_as_hash = true
    rows = db.execute('SELECT * FROM packages WHERE id=?', package_id)

    # we should get something back
    rows.any?.should be_true

    # the first row should contain the data we gave it
    rows.first['name'].should == 'package'
    rows.first['bundle'].should == 'bundle'
    rows.first['version'].should == '0.0.0'
    rows.first['author'].should == 'author'

    # cleanup
    db.close
  end

  it 'fetches packages', clean_db: true, pkg_data: true do
    package_hash = @db.fetch_package 1
    package_hash.should_not be_nil
    @package_fixtures[0].each do |k, v|
      package_hash[k.to_s].should == v
    end
  end

  it 'checks existence of a package', clean_db: true, pkg_data: true  do
    # package should exist
    @db.package_exists(2).should be_true

    # package shouldn't exist
    @db.package_exists(9999).should be_false
  end

  it 'updates packages', clean_db: true, pkg_data: true do
    new_time = Time.now + 3

    # update package
    changed = {}
    @package_fixtures[2].each {|k,v| changed[k] = v+'_changed'}
    @db.update_package 3, changed[:name], changed[:bundle], changed[:version], changed[:author], new_time

    # fetch updated package
    res = @db.fetch_package 3
    @package_fixtures[2].each do |k, v|
      res[k.to_s].should == v+'_changed'
    end
    # Compare to the second, fractional seconds are lost in db
    res['installed_on'].to_i.should == new_time.to_i
  end

  it 'deletes packages', clean_db: true, pkg_data: true do
    @db.package_exists(4).should be_true
    @db.delete_package(4)
    @db.package_exists(4).should be_false
  end

end
