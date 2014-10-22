require 'spec_helper'
require 'rake'

describe 'hockeyapp task' do
  context 'basic config', if: LineChange.config_path.end_with?('default.yml') do
    let(:app_id) { 'production_id' }
    let(:apk_path) { 'path' }

    describe 'production' do
      it 'uploads an apk to production' do
        allow(LineChange).to receive(:deploy)

        Rake::Task['line_change:production'].invoke(apk_path)

        expect(LineChange).to have_received(:deploy).with(app_id, apk_path)
      end
    end
  end
end
