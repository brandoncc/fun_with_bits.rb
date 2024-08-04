# frozen_string_literal: true

module FunWithBits
  # A bitset implementation roughly equivalent to std::bitset in C++20
  class Bitset
    class OutOfRangeError < StandardError; end

    ONE_SET_BIT_MASK = 0b1

    attr_reader :bits, :size
    protected :bits

    def initialize(size: 8, initial_value: 0b0)
      @size = size
      @bits = initial_value
    end

    def ==(other)
      bits == other.bits
    end

    def [](index)
      return nil if index >= size

      mask = ONE_SET_BIT_MASK << index

      (bits & mask).positive?
    end

    def all?
      test_bits = bits
      return false if (ONE_SET_BIT_MASK & test_bits).zero?

      (size - 1).times do
        test_bits >>= 1
        return false if (ONE_SET_BIT_MASK & test_bits).zero?
      end

      true
    end

    def any?
      test_bits = bits
      return true if ONE_SET_BIT_MASK & test_bits == 1

      (size - 1).times do
        test_bits >>= 1
        return true if ONE_SET_BIT_MASK & test_bits == 1
      end

      false
    end

    def test(index)
      self[index].tap do |value|
        raise OutOfRangeError, "index #{index} out of bounds for Bitset with size #{size}" if value.nil?
      end
    end
  end
end
