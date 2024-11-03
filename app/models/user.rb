class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :comments
  #Relacion n a n
  has_many :reactions
  has_many :posts, through: :reactions

  enum :role, [:normal_user, :author, :admin]
end
