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

  context 'config with path', if: LineChange.config_path.end_with?('config_with_path.yml') do
    describe 'staging' do
      let(:app_id) { 'staging_id' }
      let(:apk_path) { 'path/to/uploadable/staging/file' }

      it 'uploads an apk to production' do
        allow(LineChange).to receive(:deploy)

        Rake::Task['line_change:staging'].invoke

        expect(LineChange).to have_received(:deploy).with(app_id, apk_path)
      end
    end

    describe 'production' do
      let(:app_id) { 'production_id' }
      let(:apk_path) { 'path/to/uploadable/production/file' }

      it 'uploads an apk to production' do
        allow(LineChange).to receive(:deploy)

        Rake::Task['line_change:production'].invoke

        expect(LineChange).to have_received(:deploy).with(app_id, apk_path)
      end
    end
  end
end
