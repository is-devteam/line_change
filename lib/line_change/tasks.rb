require 'rake'

namespace :line_change do
  LineChange.configuration.apps.each do |app|
    desc "Upload apk to #{app.env} (app_id: #{app.app_id})"
    task app.env, :apk_path do |_, args|
      LineChange.deploy(app.app_id, args[:apk_path] || app.path)
    end
  end
end
