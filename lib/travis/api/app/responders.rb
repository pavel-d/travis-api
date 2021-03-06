require 'travis/api/app'

class Travis::Api::App
  module Responders
    autoload :Atom,    'travis/api/app/responders/atom'
    autoload :Base,    'travis/api/app/responders/base'
    autoload :Image,   'travis/api/app/responders/image'
    autoload :Badge,   'travis/api/app/responders/badge'
    autoload :Json,    'travis/api/app/responders/json'
    autoload :Plain,   'travis/api/app/responders/plain'
    autoload :Service, 'travis/api/app/responders/service'
    autoload :Xml,     'travis/api/app/responders/xml'
  end
end
