class Admin < ApplicationRecord
    devise :omniauthable, omniauth_providers: [:google_oauth2]

    validates :name, presence: true
    validates :surname, presence: true
    validates :CF, presence: true, uniqueness: true
    validates :mail, presence: true, uniqueness: true
    validates :password, presence: true

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |admin|
        admin.email = auth.info.email
        admin.password = Devise.friendly_token[0, 20]
        admin.full_name = auth.info.name
        admin.CF="77"
        admin.mail=auth.info.email
        admin.surname="mimomio"
        admin.uid=auth.uid
        admin.provider=auth.provider

      end
    end
end
