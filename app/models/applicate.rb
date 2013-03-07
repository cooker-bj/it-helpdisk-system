class Applicate < ActiveRecord::Base
has_many :wirelesses
  validates_presence_of :name,:department,:reason
end
