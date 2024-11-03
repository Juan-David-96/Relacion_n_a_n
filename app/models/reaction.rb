class Reaction < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :kind, acceptance: {accept: %w[👍 👎],}
  def self.kinds
    %w[👍 👎]
  end
   
end
