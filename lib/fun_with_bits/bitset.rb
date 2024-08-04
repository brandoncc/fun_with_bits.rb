# frozen_string_literal: true

module FunWithBits
  # A bitset implementation roughly equivalent to std::bitset in C++20
  class Bitset
    attr_reader :size

    def initialize(size: 8, initial_value: 0b0)
      @size = size
    end
  end
end
