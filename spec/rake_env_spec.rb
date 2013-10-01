require 'rspec'
require 'clara/rake_env'

# no need to test this too much
# we are extending a rake class and their tests should assure us of it's functionality
describe Clara::RakeEnv do
  before do
    @env = Clara::RakeEnv.new File.expand_path('../fixtures', __FILE__)
  end
  after { @env = nil }

  subject { @env }

  its(:name) { should == 'clara' }
  its(:original_dir) { should == File.expand_path('../fixtures', __FILE__)}

  it { should respond_to :add_import }
  it { should respond_to :invoke_task }
  it { should respond_to :load_imports }

  describe 'when it has a task' do
    before do
      # create a task
      @env.define_task Rake::Task, :my_task
    end

    it 'should find that task' do
      @env.lookup(:my_task).should_not be_nil
    end

    it 'should be able to run that task' do
      @env.invoke_task :my_task
    end
  end

  describe 'it does not have a task' do
    it 'should fail to find it' do
      @env.lookup(:my_task).should be_nil
    end

    it 'should throw an exception when it runs it' do
      lambda { @env.invoke_task(:my_task) }.should raise_exception
    end
  end
end
