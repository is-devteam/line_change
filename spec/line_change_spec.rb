
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
end
