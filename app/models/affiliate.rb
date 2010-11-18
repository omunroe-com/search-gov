class Affiliate < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :within=> (3..33)
  validates_format_of :name, :with=> /^[\w.-]+$/i
  belongs_to :owner, :class_name => 'User'
  has_and_belongs_to_many :users
  belongs_to :affiliate_template
  has_many :boosted_sites, :dependent => :destroy
  has_many :sayt_suggestions, :dependent => :destroy
  has_many :calais_related_searches, :dependent => :destroy
  after_destroy :remove_boosted_sites_from_index
  after_create :add_owner_as_user

  USAGOV_AFFILIATE_NAME = 'usasearch.gov'

  def template
    affiliate_template || DefaultAffiliateTemplate
  end
  
  def is_owner?(user)
    self.owner == user ? true : false
  end

  private

  def remove_boosted_sites_from_index
    boosted_sites.each { |bs| bs.remove_from_index }
  end
  
  def add_owner_as_user
    self.users << self.owner if self.owner
  end
end
