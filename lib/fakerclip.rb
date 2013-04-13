require 'fileutils'
require 'paperclip'
require 'fog'

module Fakerclip

  class << self

    def activate
      Reads.activate
      Writes.activate
    end
  end
end

require 'fakerclip/engine'
require 'fakerclip/reads'
require 'fakerclip/writes'
