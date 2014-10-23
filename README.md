# LineChange [![Build Status](https://travis-ci.org/is-devteam/line_change.svg?branch=master)](https://travis-ci.org/is-devteam/line_change)

Easy apk upload tasks for HockeyApp.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'line_change'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install line_change

Then add the following line to your Rakefile. If you don't have a Rakefile, just create it.

```ruby
require 'line_change/tasks'
```

Then you should be able to run the install task:

```
$ rake line_change:install
Generating a new config file: /path/to/your/project/config/line_change.yml
```

## Deployment

You need to provide your API key for HockeyApp. Open `config/line_change.yml` and set your API key to `api_key`. Also put at least one environment you want to upload an apk to:

```yaml
api_key: <your-api-key-for-HockeyApp>
apps:
  staging:
    app_id: <app-id-for-staging-app>
    path: '/path/to/apk/file/appname-staging.apk'
  production:
    app_id: <app-id-for-production-app>
    path: '/path/to/apk/file/appname-production.apk'
```

You are all set! Now you have a rake task for each environment:

```
$ rake -T
rake line_change:production  # Uploads apk to production (app_id: <app-id-for-production-app>)
rake line_change:staging     # Uploads apk to staging (app_id: <app-id-for-staging-app>)
```

And just execute one of the commands when you want to upload an apk file.

```
$ rake line_change:staging
Uploading /path/to/apk/file/appname-staging.apk to HockeyApp... Done!

Response from HockeyApp:
    version            : 42
    shortversion       : 0.4.2-42
    title              : Your App Name
    timestamp          : 123581321
    appsize            : 3141592
    notes              : <p>Build number 42</p>
    mandatory          : false
    external           : false
    device_family      :
    id                 : 42
    app_id             : 27182
    minimum_os_version : 4.2
    public_url         : https://rink.hockeyapp.net/apps/<app-id-for-staging-app>
    build_url          : https://rink.hockeyapp.net/api/2/apps/<app-id-for-staging-app>/app_versions/42?format=apk&avtoken=<some-hash-value>
    config_url         : https://rink.hockeyapp.net/manage/apps/27182/app_versions/42
    restricted_to_tags : false
    status             : 2
    tags               : []
    created_at         : 2014-10-23T14:03:45Z
    updated_at         : 2014-10-23T14:03:46Z
```

### Path Pattern
You can also set a pattern to `path`:

```yaml
...
apps:
  beta:
    ...
    path: '/path/to/apk/file/appname-staging-*.apk'
```

Then LineChange will look for the most recent modified file (based on **mtime**) from the list of files that match the pattern.

```
$ rake beta
Uploading /path/to/apk/file/appname-staging-42.apk to HockeyApp...
...
```

## Usage without Rake

You can also use LineChange without Rake. For example, you can use `#install` method if you want to install LineChange programatically:

```ruby
require 'line_change'

LineChange.install
```

It also provides `#deploy` method that uploads an apk file to HockeyApp:

```ruby
require 'line_change'

app_id      = '<App id for production app>'
path_to_apk = '/path/to/apk/file/appname-production.apk'

LineChange.deploy(app_id, path_to_apk)
```

## Supported Versions

 * MRI 2.0.0, 2.1.x, 2.2.0-preview1 and ruby-head.

## TODO

 * Add the ability to write ERB in the config.
 * Add an option to change `status`, `notify`, `notes` and `notes_type` from the config.
 * Add support for other parameters like `private` and `dsym` (see [their doc](http://support.hockeyapp.net/kb/api/api-apps#upload-app)).
 * Add support for JRuby and Rubinius.

## Contributing

1. Fork it ( https://github.com/is-devteam/line_change/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright © 2014 InSite Applications, LLC. See MIT-LICENSE for further details.