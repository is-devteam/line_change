describe LineChange::Deploy do
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
      let(:apk_path) { "spec/support/fixtures/newest.txt" }

      it "uploads the path to the connection" do
        without_output { subject.start }

        expect(connection).to have_received(:upload).with(apk_path, app_id)
      end

      it "outputs progress and result" do
        output =
          "Uploading spec/support/fixtures/newest.txt to Hockeyapp... Done!\n" \
          "\n" \
          "Response from Hockeyapp:\n" \
          "    great              : result!\n"

        expect { subject.start }.to output(output).to_stdout
      end
    end
  end

  def without_output
    org, $stdout = $stdout, double(:stdout, write: nil)
    yield
  ensure
    $stdout = org
  end
end
