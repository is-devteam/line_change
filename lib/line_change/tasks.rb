require 'rake'

namespace :line_change do
  LineChange.configuration.apps.each do |env, app_id|
    task env.to_sym, :apk_path do |_, args|
      LineChange.deploy(app_id, args[:apk_path])
    end
  end
end
