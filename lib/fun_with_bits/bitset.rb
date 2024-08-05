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

    def count
      mask = ONE_SET_BIT_MASK
      count = bits & mask

      (size - 1).times do
        mask <<= 1
        count += 1 if (bits & mask).positive?
      end

      count
    end

    def flip(index = nil)
      if index
        flip_one_bit(index)
      else
        flip_all_bits
      end
    end

    def none?
      !any?
    end

    def set(index = nil)
      if index
        set_one_bit(index)
      else
        set_all_bits
      end
    end

    def test(index)
      self[index].tap do |value|
        raise OutOfRangeError, "index #{index} out of bounds for Bitset with size #{size}" if value.nil?
      end
    end

    private

    def flip_one_bit(index)
      raise OutOfRangeError, "index #{index} out of bounds for Bitset with size #{size}" if index >= size

      mask = ONE_SET_BIT_MASK << index
      @bits ^= mask
    end

    def flip_all_bits
      mask = ONE_SET_BIT_MASK

      (size - 1).times do
        mask <<= 1
        mask |= ONE_SET_BIT_MASK
      end

      @bits ^= mask
    end

    def set_one_bit(index) # rubocop:disable Naming/AccessorMethodName
      raise OutOfRangeError, "index #{index} out of bounds for Bitset with size #{size}" if index >= size

      mask = ONE_SET_BIT_MASK
      mask <<= index

      @bits |= mask
    end

    def set_all_bits
      new_bits = ONE_SET_BIT_MASK

      (size - 1).times do
        new_bits <<= 1
        new_bits |= ONE_SET_BIT_MASK
      end

      @bits = new_bits
    end
  end
end
