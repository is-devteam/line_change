require 'spec_helper'
require 'rake'

describe 'hockeyapp task' do
  context 'basic config', if: LineChange.config_path.end_with?('hockeyapp.yml') do
    let(:app_id) { 'production_id' }
    let(:api_key) { 'apikey' }
    let(:apk_path) { 'path' }

    describe 'production' do
      it 'uploads an apk to production' do
        allow(LineChange).to receive(:deploy)

        Rake::Task['hockeyapp:production'].invoke(apk_path)

        expect(LineChange).to have_received(:deploy).with(api_key, app_id, apk_path)
      end
    end
  end
end
