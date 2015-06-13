class User < ActiveRecord::Base
  after_create :generate_auth_token

  validates_presence_of :email, :password


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def find_users_nearby(user)
    users_nearby = []
    users = User.where('id ! = ?', user.id)
    users.each do |u|
      distance_with_user = distance(user.lat, user.lng, u.lat, u.lng)
      if distance_with_user <= 20
        users_nearby << u
      end
    end
    users_nearby
  end

  private


  def distance lat1, long1, lat2, long2
    dtor = Math::PI/180
    r = 6378.14*1000

    rlat1 = lat1 * dtor
    rlong1 = long1 * dtor
    rlat2 = lat2 * dtor
    rlong2 = long2 * dtor

    dlon = rlong1 - rlong2
    dlat = rlat1 - rlat2

    a = power(Math::sin(dlat/2), 2) + Math::cos(rlat1) * Math::cos(rlat2) * power(Math::sin(dlon/2), 2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    d = r * c
    # Delete 20m from total(just for this functionality to work)
    d = d - 20
    return d
  end


  def generate_auth_token
    puts 'generate_auth_token'
    tmp_auth_token = nil
    loop do
      tmp_auth_token = Devise.friendly_token
      break if User.where(:auth_token => tmp_auth_token).count==0
    end
    self.update_attribute('auth_token', tmp_auth_token)
  end

end
