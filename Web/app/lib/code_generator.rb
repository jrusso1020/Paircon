require 'securerandom'

class CodeGenerator
  def self.code(klass, field, size)
    code = self.random_code(size)
    
    until self.code_is_unique?(klass, field, code)
      code = self.random_code(size)
    end
    
    return code
  end

  private
  def self.code_is_unique?(klass, field, code)
    return true if klass.class.send('find_by_' + field, code).nil?
  end

  def self.random_code(size)
    SecureRandom.hex(size/2)
  end
end

