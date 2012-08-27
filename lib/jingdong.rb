begin
  require "crack"
rescue LoadError
  puts "The Crack gem is not available.\nIf you ran this command from a git checkout " \
       "of Rails, please make sure crack is installed. \n "
  exit
end

require "digest/md5"
require "yaml"
require "uri"
require "rest"
require "json"

module Jingdong

  SANDBOX = 'http://gw.api.sandbox.360buy.com/routerjson?'
  PRODBOX = 'http://gw.api.360buy.com/routerjson?'
  USER_AGENT = 'jingdong_fu/1.0.0.alpha'
  REQUEST_TIMEOUT = 10
  API_VERSION = 2.0
  SIGN_ALGORITHM = 'md5'
  OUTPUT_FORMAT = 'json'

  class << self
    def setting(options)      
      @settings = options
    end
    
    def load(config_file)
      @settings = YAML.load_file(config_file)
      @settings = @settings[Rails.env] if defined? Rails.env
      apply_settings
    end

    def switch_to(sandbox_or_prodbox)
      @base_url = sandbox_or_prodbox
      @sess.base_url = @base_url if @sess
    end

    def get(options = {})
      @response = Rest.get(@settings[:base_url], generate_query_vars(sorted_params(options)))
      
puts @response.inspect
      # parse_result @response
      @response
    end

    # http://toland.github.com/patron/
    def post(options = {})
    end

    def update(options = {})
    end

    def delete(options = {})
    end
    
    def sorted_params(options)
      
      params = options.delete(:params)
      puts options.inspect, params.inspect
      options['360buy_param_json'] = params.to_json
      {
        :app_key      => @settings[:app_key],
        :access_token => @settings[:access_token],
        :format       => OUTPUT_FORMAT,
        :v            => API_VERSION,
        :sign_method  => SIGN_ALGORITHM,
        :timestamp    => Time.now.strftime("%Y-%m-%d %H:%M:%S")
      }.merge!(options)
    end

    def generate_query_vars(params)
      params[:sign] = generate_sign(params.sort_by { |k,v| k.to_s }.flatten.join)
      params
    end

    def generate_query_string(params)
      sign_token = generate_sign(params_array.flatten.join)
      total_param = params_array.map { |key, value| key.to_s+"="+value.to_s } + ["sign=#{sign_token}"]
      URI.escape(total_param.join("&"))
    end

    def generate_sign(param_string)
      Digest::MD5.hexdigest(@settings[:app_secret] + param_string + @settings[:app_secret]).upcase
    end

    def parse_result(data)
      Crack::JSON.parse(data)
    end

  end

end
