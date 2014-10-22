
describe LineChange do
  describe '.configuration', if: LineChange.config_path.end_with?('default.yml') do
    subject { LineChange.configuration }

    it 'provides a getter for api_key' do
      expect(subject.api_key).to eq('api_key')
    end

    it 'provides a getter for apps' do
      expect(subject.apps). to eq({
        'production' => 'production_id'
      })
    end
  end

  describe '.deploy' do
    let(:app_id) { 'app_id' }
    let(:apk_path) { 'apk_path' }
    let(:deploy) { instance_double(LineChange::Deploy) }

    subject { LineChange.deploy(app_id, apk_path) }

    before do
      allow(LineChange::Deploy).to receive(:new).with(app_id, apk_path).and_return(deploy)
      allow(deploy).to receive(:start)
    end

    it "instantiates a deploy object with the api key" do
      subject

      expect(LineChange::Deploy).to have_received(:new).with(app_id, apk_path)
    end

    it "deploys the apk with the app id" do
      subject

      expect(deploy).to have_received(:start)
    end
  end
end
