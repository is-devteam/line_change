describe LineChange::Deploy, if: default? do
  describe '#start' do
    let(:app_id) { 'app id' }
    let(:connection) { instance_double(LineChange::Connection) }
    let(:response) { double(:response, body: {'great' => 'result!'}) }

    subject { LineChange::Deploy.new(app_id, apk_path) }

    before do
      allow(LineChange::Connection).to receive(:new).and_return(connection)
      allow(connection).to receive(:upload) { response }
    end

    context "when file exists" do
      let(:apk_path) { "spec/support/fixtures/*.txt" }

      it "uploads the path to the connection" do
        without_output { subject.start }

        expect(connection).to have_received(:upload).with("spec/support/fixtures/newest.txt", app_id)
      end

      it "outputs progress and result" do
        output =
          "Uploading spec/support/fixtures/newest.txt to HockeyApp... Done!\n" \
          "\n" \
          "Response from HockeyApp:\n" \
          "    great              : result!\n"

        expect { subject.start }.to output(output).to_stdout
      end
    end

    context "when file doesn't exist" do
      let(:apk_path) { "does/not/exist" }

      it "raises an error" do
        expect { subject.start }.to raise_error(LineChange::FileNotFound)
      end
    end
  end
end
