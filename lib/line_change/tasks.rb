require 'rake'

namespace :line_change do
  LineChange.configuration.apps.each do |app|
    desc "Uploads apk to #{app.env} (app_id: #{app.app_id})"

    if app.path
      task(app.env){ LineChange.deploy(app.app_id, app.path) }
    else
      task(app.env, :apk_path){|_, args| LineChange.deploy(app.app_id, args[:apk_path]) }
    end
  end if LineChange::Configuration.exists?

  desc 'Creates a config file in config/line_change.yml'
  task :install do
    LineChange.install
  end
end
