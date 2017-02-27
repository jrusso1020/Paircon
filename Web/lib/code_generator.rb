require 'securerandom'

class CodeGenerator
  def self.code(klass, field, size)
    code = self.random_code(size)
    duplication_found = false
    
    until self.code_is_unique?(klass, field, code)
      code = self.random_code(size)
      duplication_found = true
    end
    
    return code
  end

  private
  def self.code_is_unique?(klass, field, code)
    return true if klass.class.send('find_by_' + field, code).nil?
  end

  def self.random_code(size)
    #    charset = %w{ 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H J K L M N O P Q R T U V W X Y Z }
    #    (0...size).map { charset.to_a[rand(charset.size)] }.join
    #    
    #    rand(36**size).to_s(36) 
    
    SecureRandom.hex(size/2)
  end
end

