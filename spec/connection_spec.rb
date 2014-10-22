describe LineChange::Connection, if: default? do
  describe '#upload' do
    let(:stubs) { Faraday::Adapter::Test::Stubs.new }
    let(:adapters) { [:test, stubs] }
    let(:app_id) { 'app_id' }
    let(:api_key) { 'api key' }
    let(:apk_path) { '/path/app.apk' }
    let(:apk_file) { double(:apk_file, to_s: 'apk_file') }

    before do
      allow(Faraday::UploadIO).to receive(:new) { apk_file }
    end

    subject { LineChange::Connection.new(adapters).upload(apk_path, app_id) }

    context 'when success' do
      before do
        stubs.post("/api/2/apps/#{app_id}/app_versions/upload") do |env|
          @request_body = env.body
          [200, {}, response_body.to_json]
        end

        allow(LineChange.configuration).to receive(:api_key) { api_key }
      end

      let(:response_body) { {'success' => true} }

      it 'post the request' do
        expect(subject).to be_success
      end

      it 'makes the request with the api key header' do
        expect(subject.env.request_headers[LineChange::Connection::API_KEY_HEADER]).to eq api_key
      end

      it 'makes the request with the body' do
        subject

        expect(@request_body).to eq('ipa=apk_file&notes=Build+file+app.apk&notes_type=0&notify=0&status=2')
      end
    end

    context 'when failure' do
      before do
        stubs.post("/api/2/apps/#{app_id}/app_versions/upload") { response }
      end

      context 'when status is 404' do
        let(:response_body) do
          {
            "errors" => {
              "app" => ["not found"]
            }
          }
        end

        let(:response) { [404, {}, response_body.to_json] }

        it 'raises LineChange::NotFound' do
          expect { subject }.to raise_error(LineChange::ResourceNotFound) do |error|
            expect(error.message).to eq("App not found")
            expect(error.status).to eq(404)
            expect(error.headers).to eq({})
            expect(error.body).to eq(response_body)
          end
        end
      end

      context 'when status is 405' do
        let(:response) { [405, {}, '<html><h1>405 Not Allowed</h1></html>'] }

        it 'raises LineChange::NotFound' do
          expect { subject }.to raise_error(LineChange::MethodNotAllowed) do |error|
            expect(error.message).to eq("<html><h1>405 Not Allowed</h1></html>")
            expect(error.status).to eq(405)
            expect(error.headers).to eq({})
            expect(error.body).to eq("<html><h1>405 Not Allowed</h1></html>")
          end
        end
      end

      context 'when status is 415' do
        let(:response) { [415, {}, '<html>h1>415 Unsupported Media Type</h1></html>'] }

        it 'raises LineChange::NotFound' do
          expect { subject }.to raise_error(LineChange::UnsupportedMediaType)
        end
      end

      context 'when status is 422' do
        let(:response_body) do
          {
            "status" => "error",
            "message" => "Bundle version is blank."
          }
        end

        let(:response) { [422, {}, response_body.to_json] }

        it 'raises LineChange::UnprocessableEntity' do
          expect { subject }.to raise_error(LineChange::UnprocessableEntity) do |error|
            expect(error.message).to eq("Bundle version is blank.")
            expect(error.status).to eq(422)
            expect(error.headers).to eq({})
            expect(error.body).to eq(response_body)
          end
        end
      end

      context 'when status is other client error status' do
        let(:response) { [403, {}, ''] }

        it 'raises LineChange::NotFound' do
          expect { subject }.to raise_error(LineChange::ClientError)
        end
      end

      context 'when status is 500' do
        let(:response) { [500, {}, ''] }

        it 'raises LineChange::ServerError' do
          expect { subject }.to raise_error(LineChange::ServerError)
        end
      end
    end
  end
end
