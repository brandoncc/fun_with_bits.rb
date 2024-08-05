# frozen_string_literal: true

module FunWithBits
  # A bitset implementation roughly equivalent to std::bitset in C++20
  class Bitset
    class OutOfRangeError < StandardError; end
    class SetsMustHaveSameSizeError < StandardError; end

    NO_BITS_SET_MASK = 0b0
    ONE_SET_BIT_MASK = 0b1

    attr_reader :bits, :size
    protected :bits

    def initialize(size: 8, initial_value: NO_BITS_SET_MASK)
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

    def ~
      Bitset.new(initial_value: bits, size: size).tap(&:flip)
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

    def and!(other)
      raise SetsMustHaveSameSizeError unless other.size == size

      new_bits = NO_BITS_SET_MASK

      size.downto(0) do |index|
        new_bits <<= 1

        new_bits |= ONE_SET_BIT_MASK if self[index] && other[index]
      end

      @bits = new_bits
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

    def or!(other)
      raise SetsMustHaveSameSizeError unless other.size == size

      new_bits = NO_BITS_SET_MASK

      size.downto(0) do |index|
        new_bits <<= 1

        new_bits |= ONE_SET_BIT_MASK if self[index] || other[index]
      end

      @bits = new_bits
    end

    def reset(index = nil)
      if index
        raise OutOfRangeError, "index #{index} out of bounds for Bitset with size #{size}" if index >= size

        flip(index) if self[index]
      else
        @bits &= 0b0
      end
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

    def xor!(other)
      raise SetsMustHaveSameSizeError unless other.size == size

      new_bits = NO_BITS_SET_MASK

      (size - 1).downto(0) do |index|
        self_bit = self[index]
        other_bit = other[index]

        new_bits <<= 1
        new_bits |= ONE_SET_BIT_MASK if (self_bit && !other_bit) || (!self_bit && other_bit)
      end

      @bits = new_bits
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
