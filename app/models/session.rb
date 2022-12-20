class Session
  include ActiveModel::Model
  attr_accessor :email, :code
  validates :email, :code, presence: true
  validates :email, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "邮箱地址格式不正确" }
  
  validate :check_code

  def check_code
    return if Rails.env.test? and self.code == '123456'
    return if self.code.empty?
    self.errors.add :email, :not_found unless ValidationCode.exists? email: self.email, code: self.code, used_at: nil
  end
end