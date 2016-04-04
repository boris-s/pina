require 'active_support'
require 'base64'
require 'json'
require 'typhoeus'
require 'virtus'

require 'pina/contact'
require 'pina/sales_invoice'
require 'pina/version'
require 'pina/rest_adapter'

require 'pina/utils/pagination'

require 'pina/models/address'
require 'pina/models/contact'
require 'pina/models/contact_list'
require 'pina/models/sales_item'
require 'pina/models/sales_invoice'
require 'pina/models/sales_invoice_list'

module Pina
  class ConfigurationNotSet < StandardError; end

  DEFAULT_API_VERSION = :v1
  DEFAULT_EMAIL       = 'dummy@email.com'
  DEFAULT_TENANT      = 'imaginary'

  SCHEME              = 'https://'
  API_PATH            = '.ucetnictvi.bonobo.cz/api/'

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      self.configuration.clear
      yield(configuration)
    end
  end

  class Configuration
    attr_accessor :api_token, :email, :tenant
    attr_reader :api_version

    def initialize
      clear
    end

    def clear
      @api_version = DEFAULT_API_VERSION
      @email       = DEFAULT_EMAIL
      @tenant      = DEFAULT_TENANT
      @endpoint    = nil
    end

    def endpoint=(endpoint)
      @endpoint = endpoint
    end

    def endpoint
      @endpoint ||= SCHEME + tenant + API_PATH + "#{api_version}/"
    end
  end
end
