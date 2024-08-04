# frozen_string_literal: true

require "test_helper"

module FunWithBits
  class TestBitset < Minitest::Test # rubocop:disable Metrics/ClassLength
    def test_initializer_has_default_values
      bitset = Bitset.new

      assert_instance_of Bitset, bitset
    end

    def test_initializer_accepts_initial_bitmap
      bitset = Bitset.new(initial_value: 0b1111)

      assert_instance_of Bitset, bitset
    end

    def test_initializer_accepts_size
      bitset = Bitset.new(size: 16)

      assert_instance_of Bitset, bitset
    end
  end
end
