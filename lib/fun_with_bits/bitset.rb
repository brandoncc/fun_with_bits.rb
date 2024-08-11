# frozen_string_literal: true

module FunWithBits
  # A bitset implementation roughly equivalent to std::bitset in C++20
  class Bitset # rubocop:disable Metrics/ClassLength
    class OutOfRangeError < StandardError; end
    class SetsMustHaveSameSizeError < StandardError; end

    NO_BITS_SET_MASK = 0b0
    ONE_SET_BIT_MASK = 0b1

    attr_reader :bits, :size
    protected :bits

    def initialize(size: 8, initial_value: NO_BITS_SET_MASK)
      raise ArgumentError, "size must be greater than 1" if size < 1

      @size = size
      @bits = initial_value
      truncate_bits_to_proper_size!
    end

    def ==(other)
      return false unless other.is_a?(Bitset)

      bits == other.bits
    end

    def [](index)
      raise ArgumentError, "index cannot be a negative number" if index.negative?
      return nil if index >= size

      mask = ONE_SET_BIT_MASK << index

      (bits & mask).positive?
    end

    def ~
      Bitset.new(initial_value: bits, size: size).tap(&:flip)
    end

    def shift_left(distance)
      Bitset.new(initial_value: bits, size: size).tap do |new_bitset|
        new_bitset.shift_left!(distance)
      end
    end

    def shift_left!(distance)
      raise ArgumentError, "distance cannot be negative" if distance.negative?

      @bits <<= distance
      truncate_bits_to_proper_size!
    end

    def shift_right(distance)
      Bitset.new(initial_value: bits, size: size).tap do |new_bitset|
        new_bitset.shift_right!(distance)
      end
    end

    def shift_right!(distance)
      raise ArgumentError, "distance cannot be negative" if distance.negative?

      @bits >>= distance
    end

    def all?
      mask = (1 << size) - 1

      bits == mask
    end

    def and!(other)
      raise ArgumentError, "must provide an instance of Bitset as the argument" unless other.is_a?(Bitset)
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
        raise ArgumentError, "index cannot be negative" if index.negative?

        flip_one_bit(index)
      else
        flip_all_bits
      end
    end

    def none?
      !any?
    end

    def or!(other)
      raise ArgumentError, "must provide an instance of Bitset as the argument" unless other.is_a?(Bitset)
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
        raise ArgumentError, "index cannot be negative" if index.negative?

        set_one_bit(index)
      else
        set_all_bits
      end
    end

    def test(index)
      raise ArgumentError if index.negative?
      raise OutOfRangeError, "index #{index} out of bounds for Bitset with size #{size}" unless (0...size).cover?(index)

      self[index]
    end

    def to_i
      total_value = 0
      bit_value = 1

      (0...size).each do |index|
        total_value += bit_value if self[index]
        bit_value *= 2
      end

      total_value
    end

    def to_s
      output = StringIO.new

      (size - 1).downto(0) do |index|
        output << (self[index] ? "1" : "0")
      end

      output.tap(&:rewind).read
    end

    def xor!(other)
      raise ArgumentError, "must provide an instance of Bitset as the argument" unless other.is_a?(Bitset)
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
      raise ArgumentError, "index cannot be negative" if index.negative?
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
      raise ArgumentError, "index cannot be negative" if index.negative?
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

    def truncate_bits_to_proper_size!
      size_mask = ONE_SET_BIT_MASK

      (size - 1).times do
        size_mask <<= 1
        size_mask ^= ONE_SET_BIT_MASK
      end

      @bits &= size_mask
    end
  end
end
