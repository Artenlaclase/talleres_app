class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :estudiante, dependent: :destroy

  enum :role, { usuario: 'usuario', admin: 'admin' }, default: :usuario

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :activos, -> { where(locked_at: nil) }
  scope :admins, -> { where(role: 'admin') }

  def admin?
    role == 'admin'
  end

  def usuario?
    role == 'usuario'
  end

  def lock_account
    update(locked_at: Time.current)
  end

  def unlock_account
    update(locked_at: nil)
  end

  def locked?
    locked_at.present?
  end
end
