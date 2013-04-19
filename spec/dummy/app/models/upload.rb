class Upload < ActiveRecord::Base

  attr_accessible :file

  def image?
    false
  end
end
