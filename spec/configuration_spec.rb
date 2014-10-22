describe LineChange::Configuration do
  describe '#apps' do
    subject { configuration.apps.first }

    context 'with string hash' do
      let(:configuration) { LineChange::Configuration.new("apps" => {"prod" => "prod-app-id"}) }

      it "accesses the apps" do
        expect(subject.env).to eq("prod")
        expect(subject.app_id).to eq("prod-app-id")
      end
    end

    context 'with symbol hash' do
      let(:configuration) { LineChange::Configuration.new(apps: {prod: "prod-app-id"}) }

      it "accesses the apps" do
        expect(subject.env).to eq("prod")
        expect(subject.app_id).to eq("prod-app-id")
      end
    end

    context 'with multiple environments' do
      let(:configuration) do
        LineChange::Configuration.new(apps: {
          staging: {
            app_id: "staging-app-id",
            path: "/path/to/staging/apk"
          },
          production: {
            app_id: "production-app-id",
            path: "/path/to/production/apk"
          }
        })
      end

      describe "first app config" do
        subject { configuration.apps[0] }

        it "accesses the apps" do
          expect(subject.env).to eq("staging")
          expect(subject.app_id).to eq("staging-app-id")
          expect(subject.path).to eq("/path/to/staging/apk")
        end
      end

      describe "second app config" do
        subject { configuration.apps[1] }

        it "accesses the apps" do
          expect(subject.env).to eq("production")
          expect(subject.app_id).to eq("production-app-id")
          expect(subject.path).to eq("/path/to/production/apk")
        end
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
