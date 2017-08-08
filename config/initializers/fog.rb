if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end

elsif Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',                         # required
      :aws_access_key_id      => ENV['aws_access_key_id'],      # required
      :aws_secret_access_key  => ENV['aws_secret_access_key'],   # required
      :region                 => 'us-west-1'                   # optional, defaults to 'us-east-1'
      #:host                   => 's3.example.com',             # optional, defaults to nil
      #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.storage = :fog
    config.fog_directory  = ENV['aws_prod_dir']                          # required
    config.fog_public     = false                                        # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
    config.fog_authenticated_url_expiration = 60000 # 1000 minutes
  end

elsif Rails.env.development?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',                         # required
      :aws_access_key_id      => ENV['aws_access_key_id'],      # required
      :aws_secret_access_key  => ENV['aws_secret_access_key'],   # required
      :region                 => 'us-east-1'                 # optional, defaults to 'us-east-1'
      #:host                   => 's3.example.com',             # optional, defaults to nil
      #:endpoint               => 'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.storage = :fog
    config.fog_directory  = ENV['aws_dev_dir']                          # required
    config.fog_public     = false                                        # optional, defaults to true
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {}
    config.fog_authenticated_url_expiration = 60000 # 1000 minutes
  end

end
