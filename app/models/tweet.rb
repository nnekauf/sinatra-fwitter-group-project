class Tweet < ActiveRecord::Base
  # include Slugifiable::InstanceMethods

  belongs_to :user
  validates_presence_of :content
 
  
end
