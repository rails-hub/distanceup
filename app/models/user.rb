class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
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

end
