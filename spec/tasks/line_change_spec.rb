require 'spec_helper'

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

  describe 'install task', if: LineChange.config_path.end_with?('installer.yml') do
    before do
      Rake::Task['line_change:install'].reenable
    end

    after do
      File.delete(LineChange.config_path) if File.exist?(LineChange.config_path)
    end

    context "when config file doesn't exist" do
      it 'generates an exmaple config file' do
        without_output { Rake::Task['line_change:install'].invoke }

        expect(File).to exist(LineChange.config_path)
        expect(open(File.expand_path("lib/line_change/templates/line_change.yml")).read). to eq(open(LineChange.config_path).read)
      end

      it "tells it is creating a new config file" do
        expect do
          Rake::Task['line_change:install'].invoke
        end.to output("Generating a new config file: #{LineChange.config_path}\n").to_stdout
      end
    end

    context "when config file already exists" do
      before do
        without_output { Rake::Task['line_change:install'].invoke }
        Rake::Task['line_change:install'].reenable
      end

      it "doesn't do anything" do
        sleep(1)

        expect do
          without_output { Rake::Task['line_change:install'].invoke }
        end.not_to change { File.open(LineChange.config_path).mtime }
      end

      it "tells it is skipping execution" do
        expect do
          Rake::Task['line_change:install'].invoke
        end.to output("You already have a config file in #{LineChange.config_path}!\n").to_stdout
      end
    end
  end
end
