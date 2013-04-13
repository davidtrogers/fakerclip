module Fakerclip
  class Engine < ::Rails::Engine

    initializer 'fakerclip.load_fakerclip' do |app|
      if ['development', 'test'].include?(Rails.env)
        Fakerclip.activate
      end
    end
  end
end
