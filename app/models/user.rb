class User < ApplicationRecord
  
  has_many :attendances, dependent: :destroy
  
  attr_accessor :remember_token
  
  before_save { self.email=email.downcase}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, presence:true, length:{maximum: 50}
  validates :email, presence:true, length:{maximum:100},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness:true
  
  
  has_secure_password
  validates :password, presence:true, length:{minimum:6}, allow_nil:true
  
  
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  
  
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token=User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remmeber_token)
    return false if remmeber_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest,nil)
  end
  
  
  
  #以下CSV#
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      unless user = User.find_by(email: row["email"])
        user = User.new        
        user.attributes = row.to_hash.slice(*updatable_attributes)
        user.save!
        return 0
      else
        user.attributes = row.to_hash.slice(*updatable_attributes)
        user.save!
        return 1    
      end
    end
  end
  
  
  def self.updatable_attributes
    ["name", "email", "affiliation", "employee_number", "uid", "basic_work_time", "designated_work_start_time", "designated_work_end_time", "superior", "admin", "password"]
  end


  
  
  
end
