require 'rails_helper'

RSpec.describe User, type: :model do
  it "é valido quando tem pelo menos 9 caracteres" do
    user = User.new(email: "teste@examplo.com", password: '123456789')
    expect(user).to be_valid
  end

  it "nao é valido quando tem pelo menos 9 caracteres" do
    user = User.new(email: "teste@examplo.com", password: '12345678')
    user.valid?
    expect(user.errors[:password]).to include("a senha é muito curta (9 caracteres no mínimo)")
  end
end
