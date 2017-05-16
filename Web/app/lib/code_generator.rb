# Class used to handle ID Generation
class CodeGenerator

  require 'securerandom'

  # Create Unique HEX Codes
  # @param klass [Class] Name of class
  # @param field [String] Name of Field
  # @param Size [Int] of the random code
  # @return [Boolean] True if unique
  def self.code(klass, field, size)
    code = self.random_code(size)

    until self.code_is_unique?(klass, field, code)
      code = self.random_code(size)
    end

    return code
  end

  private

  # Check if the code is unique
  # @param klass [Class] Name of class
  # @param field [String] Name of Field
  # @param code [String] Hex Code
  # @return [Boolean] True if unique
  def self.code_is_unique?(klass, field, code)
    return true if klass.class.send('find_by_' + field, code).nil?
  end

  # Generate Random Code
  # @param Size [Int] of the random code
  # @return [String] Return Hex of Size / 2
  def self.random_code(size)
    SecureRandom.hex(size/2)
  end
end

