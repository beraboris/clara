require 'spec_helper'

describe Clara::Template do
  it 'should render erubis templates' do
    erb = '<% 5.times do %>Na<% end %> Batman!'
    template = Clara::Template.new erb

    result = template.result

    expect(result).to eq 'NaNaNaNaNa Batman!'
  end
end
