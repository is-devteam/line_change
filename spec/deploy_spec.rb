describe LineChange::Deploy do
  describe '#start' do
    let(:apk_path) { 'apk path' }
    let(:app_id) { 'app id' }
    let(:connection) { instance_double(LineChange::Connection) }

    subject { LineChange::Deploy.new(app_id, apk_path) }

    it "uploads the path to the connection" do
      allow(LineChange::Connection).to receive(:new).and_return(connection)
      allow(connection).to receive(:upload)

      subject.start

      expect(connection).to have_received(:upload).with(apk_path, app_id)
    end
  end
end
