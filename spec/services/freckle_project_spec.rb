require 'rails_helper'

RSpec.describe FreckleProject, type: :model do
  let(:internal_project) do
    p = FreckleProject.new(OpenStruct.new(id: 1))
    allow(p).to receive(:internal?).and_return(true)
    p
  end
  let(:external_project) do
    p = FreckleProject.new(OpenStruct.new(id: 2))
    allow(p).to receive(:internal?).and_return(false)
    p
  end
  let(:projects) do
    [
      internal_project,
      internal_project,
      external_project,
      external_project
    ]
  end

  describe '.all' do
    it 'calls get_projects on API' do
      expect(FreckleApi.instance)
        .to receive(:projects).and_return([])
      FreckleProject.all
    end
  end

  describe '.internal' do
    it 'calls get_projects on API' do
      expect(FreckleProject)
        .to receive(:all).and_return(projects)
      expect(FreckleProject.internal.size).to eq(2)
    end
  end

  describe '#entries' do
    it 'calss entries_for_project on API' do
      expect(FreckleApi.instance).to receive(:entries_for_project)
        .with(1, {})
        .and_return([])
      expect(internal_project.entries).to eq([])
    end

    it 'calls entries_for_project on API' do
      expect(FreckleApi.instance).to receive(:entries_for_project)
        .with(1, :today)
        .and_return([])
      expect(internal_project.entries(:today)).to eq([])
    end
  end

  describe '#copy_entry' do
    let(:params) do
      {
        date: Time.zone.now.strftime('%Y-%m-%d'),
        user_id: 1,
        minutes: 75,
        description: 'test',
        project_id: 1,
        source_url: 'http://www.ya.ru'
      }
    end
    let(:entry) do
      FreckleEntry.new(
        OpenStruct.new(params)
      )
    end
    let(:destination_project) do
      FreckleProject.new(
        OpenStruct.new(id: 2)
      )
    end
    it 'can create entry copy on other project' do
      expect(FreckleApi.instance).to receive(:create_entry)
        .with(params.merge(project_id: destination_project.id))

      entry.copy_to(destination_project)
    end
  end
end
