require 'rails_helper'

RSpec.describe FreckleApi, type: :model do
  let(:subject) { FreckleApi.instance }

  it 'should be defined' do
    expect(subject).to be_truthy
  end
end
