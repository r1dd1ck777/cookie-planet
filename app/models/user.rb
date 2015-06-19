class User < ActiveRecord::Base
  has_many :user_prices
  has_many :recipes
  has_and_belongs_to_many :wanted_recipes, :join_table => :favourite_recipes, class_name: "Recipe",
                          foreign_key: :user_id, association_foreign_key: :recipe_id
  has_and_belongs_to_many :watched_recipes, :join_table => :watched_recipes, class_name: "Recipe",
                          foreign_key: :user_id, association_foreign_key: :recipe_id


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates_presence_of :email
  has_many :authorizations
  mount_uploader :image, UserImageUploader

  def full_name
    fname.present? && lname.present? ? ( "#{fname} #{lname}" ) : (fname.present? ? fname : email)
  end

  def in_wanted? recipe
    wanted_recipes.include? recipe
  end

  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :secret => auth.credentials.secret).first_or_initialize
    authorization.token = auth.credentials.token
    if authorization.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0,10]
        user.fname = auth.info.first_name
        user.lname = auth.info.last_name
        user.email = auth.info.email.nil? ? Devise.friendly_token[0,10] + '@no.mail' : auth.info.email
        user = self.send("fetch_user_from_#{auth.provider.downcase}", auth, user)
        user.save
      end
      authorization.username = auth.info.nickname
      authorization.user_id = user.id
      authorization.save
    end
    authorization.user
  end

  protected

  def self.fetch_user_from_vkontakte auth, user
    user.remote_image_url = auth.extra.raw_info.photo_200_orig
    user
  end

  def self.fetch_user_from_facebook auth, user
    # user.remote_image_url = auth.info.image.to_s
    user
  end

end
