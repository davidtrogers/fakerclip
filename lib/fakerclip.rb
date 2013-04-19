# TODO: move these where they are needed
require 'fileutils'
require 'paperclip'
require 'fog'
require 'artifice'

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
