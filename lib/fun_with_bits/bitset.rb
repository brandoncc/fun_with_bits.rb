# frozen_string_literal: true

module FunWithBits
  # A bitset implementation roughly equivalent to std::bitset in C++20
  class Bitset
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

      mask = 0b1 << index

      (bits & mask).positive?
    end
  end
end
