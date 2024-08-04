# frozen_string_literal: true

require "test_helper"

module FunWithBits
  class TestBitset < Minitest::Test # rubocop:disable Metrics/ClassLength
    def test_initializer_has_default_values
      bitset = Bitset.new

      assert_instance_of Bitset, bitset
      assert_instance_of Integer, bitset.size
    end

    def test_initializer_accepts_initial_bitmap
      bitset = Bitset.new(initial_value: 0b1111)

      assert_instance_of Bitset, bitset
    end

    def test_initializer_accepts_size
      bitset = Bitset.new(size: 16)

      assert_instance_of Bitset, bitset
    end

    def test_instances_are_equivalent_if_bits_are_equivalent
      bitset1 = Bitset.new(initial_value: 0b1111)
      bitset2 = Bitset.new(initial_value: 0b1111)

      assert_equal bitset1, bitset2
    end

    def test_instances_are_not_equivalent_if_bits_are_not_equivalent
      bitset1 = Bitset.new(initial_value: 0b1111)
      bitset2 = Bitset.new(initial_value: 0b1010)

      refute_equal bitset1, bitset2
    end

    def test_size_returns_the_number_of_bits_that_the_bitset_holds
      bitset = Bitset.new(size: 18)

      assert_equal 18, bitset.size
    end
  end
end
