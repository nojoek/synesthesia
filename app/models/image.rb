class Image < ActiveRecord::Base
  attr_accessible :description, :name, :url, :file

  belongs_to :user
  has_many :sounds, dependent: :destroy
  validates :name, :presence => true, :length => { :maximum => 50 }
  validates :file, :presence => true
  has_attached_file :file, :styles => { :medium => "300x300#", :thumb => "100x100#" }, :default_url => "/assets/:style/missing.png", dependent: :destroy

  def self.last_n(n, user_id = nil)
  	if user_id.present?
  		return Image.where(:user_id => user_id).order("created_at DESC").limit(n)
  	else
  		return Image.order("created_at DESC").limit(n)
  	end
  end


  def self.last_n_syneths(n)
    res = []
    Image.last_n(n).each do |image|
      res << [image, image.sounds[0]]
    end
    puts res
    return res
  end
end
