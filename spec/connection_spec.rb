describe LineChange::Connection do
  describe '#upload' do
    let(:adapters) do
      [
        :test,
        Faraday::Adapter::Test::Stubs.new do |stub|
          stub.post("/api/2/apps/#{app_id}/app_versions/upload") do |env| 
            @request_body = env.body
            [200, {}, response_body] 
          end
        end
      ]
    end
    let(:app_id) { 'app_id' }
    let(:api_key) { 'api key' }
    let(:apk_path) { '/path/app.apk' }
    let(:apk_file) { double(:apk_file, to_s: 'apk_file') }

    before do
      allow(LineChange.configuration).to receive(:api_key) { api_key }
      allow(Faraday::UploadIO).to receive(:new) { apk_file }
    end

    subject { LineChange::Connection.new(adapters) }

    context 'when successfull upload' do
      let(:response_body) { {'success' => true} }

      it 'post the request' do
        response = subject.upload(apk_path, app_id)

        expect(response).to be_success
      end

      it 'makes the request with the api key header' do
        response = subject.upload(apk_path, app_id)

        expect(response.env.request_headers[LineChange::Connection::API_KEY_HEADER]).to eq api_key
      end

      it 'makes the request with the body' do
        subject.upload(apk_path, app_id)

        expect(@request_body).to eq('ipa=apk_file&notes=Build+file+app.apk&notes_type=0&notify=0&status=2')
      end
    end
  end
end
