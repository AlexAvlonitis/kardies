class EncryptId
  def initialize(object_id)
    @object_id = object_id
  end

  def cipher_key
    'protect_from_bad_guys'
  end

  def cipher
    OpenSSL::Cipher::Cipher.new('aes-256-cbc')
  end

  def encrypt
    c = cipher.encrypt
    c.key = Digest::SHA256.digest(cipher_key)
    Base64.encode64(c.update(@object_id.to_s) + c.final)
  end

  def decrypt
    c = cipher.decrypt
    c.key = Digest::SHA256.digest(cipher_key)
    c.update(Base64.decode64(@object_id.to_s)) + c.final
  end
end
