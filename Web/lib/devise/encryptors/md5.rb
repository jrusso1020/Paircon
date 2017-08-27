module Devise
  module Encryptable
    module Encryptors
      class Md5 < Base

        # Create MD5 For Password
        # @return [Digest] Return MD5 based on password string
        def self.digest(password, stretches, salt, pepper)
          str = [password, salt].flatten.compact.join
          Digest::MD5.hexdigest(str)
        end
      end
    end
  end
end