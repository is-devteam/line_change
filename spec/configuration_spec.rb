describe LineChange::Configuration do
  describe '#apps' do
    subject { configuration.apps }

    context 'with string hash' do
      let(:configuration) { LineChange::Configuration.new({'apps' => {foo: :bar}}) }

      it "accesses the apps" do
        expect(subject).to eq({foo: :bar})
      end
    end

    context 'with symbol hash' do
      let(:configuration) { LineChange::Configuration.new({apps: {foo: :bar}}) }

      it "accesses the apps" do
        expect(subject).to eq({foo: :bar})
      end
    end
  end

  describe '#api_key' do
    subject { configuration.api_key }

    context 'with string hash' do
      let(:configuration) { LineChange::Configuration.new({'api_key' => 'bar'}) }

      it "accesses the api key" do
        expect(subject).to eq('bar')
      end
    end

    context 'with symbol hash' do
      let(:configuration) { LineChange::Configuration.new({api_key: 'bar'}) }

      it "accesses the api key" do
        expect(subject).to eq('bar')
      end
    end
  end
end
