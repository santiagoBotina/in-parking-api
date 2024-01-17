module Validators

  def self.email?(value)
    /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(value) != nil
  end

  def self.no_spaces?(value)
    /^\S*$/.match(value) != nil
  end
end