require 'rake'

namespace :line_change do
  api_key = LineChange.configuration.api_key
  apps = LineChange.configuration.apps

  apps.each do |env, app_id|
    task env.to_sym, :apk_path do |_, args|
      LineChange.deploy(api_key, app_id, args[:apk_path])
    end
  end
end
