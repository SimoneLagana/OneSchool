class Teacher < User
    validates :birthdate, absence: true
    validates :student_class_code, absence: true
    has_many :commitments

    attribute :first_login, :boolean, default: true

    def self.from_omniauth(auth,cf, name, surname)
        user = Teacher.where(provider: auth.provider, uid: auth.uid, CF: auth.uid).first
        if user
          user.update(access_token: auth.credentials.token)
          user.update(expires_at: auth.credentials.expires_at)
          user.update(refresh_token: auth.credentials.refresh_token)
          return user
        else
          #registered_user = Teacher.where(provider: auth.try(:provider) || auth["provider"], uid: auth.try(:uid) || auth["uid"]).first || Teacher.where(mail: auth.try(:info).try(:email) || auth["info"]["email"]).first
          #if registered_user
          #  unless registered_user.provider == (auth.try(:provider) || auth["provider"]) && registered_user.uid == (auth.try(:uid) || auth["provider"])
          #    registered_user.update_attributes(provider: auth.try(:provider) || auth["provider"], uid: auth.try(:uid) || auth["uid"])
          #  end
          #  return registered_user
          
          school_code=Teacher.where(CF: cf).pluck(:school_code).uniq.first.to_s
          puts(school_code)
          user = Teacher.new(
              provider: auth.provider, 
              uid: auth.uid, 
              #mail: auth.try(:info).try(:email) || auth["info"]["email"],
              mail: auth.info.email,
              password: Devise.friendly_token[0,20],
              school_code: school_code,
              CF: auth.uid,
              name: name,
              surname: surname,
              type: "Teacher")
          user.access_token = auth.credentials.token
          user.expires_at = auth.credentials.expires_at
          user.refresh_token = auth.credentials.refresh_token
          user.save
          puts user
          
          user
        end
      end
      
end
