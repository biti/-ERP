# encoding: utf-8

require "digest/md5"
require "uri"
require "rest"
require "json"

module Paipai
  
  class << self
    
    def get(url, options = {})
      Rails.logger.info "[paipai request]==========%s %s" % [url, options.inspect]
      response = Rest.get(url, generate_query_vars(options))
      JSON.parse(response)
    end

    def post(options = {})
    end

    def update(options = {})
    end

    def delete(options = {})
    end
    
    def generate_query_vars(options)      

      cmdid = options.delete('cmdid')
      skey = options.delete('skey')

      # 计算签名
      sign_string = cmdid + options.map{ |s| "#{s.first}#{s.last}" }.sort.join + skey
      options[:sign] = Digest::MD5.hexdigest(sign_string) 

      options
    end

  end

end
