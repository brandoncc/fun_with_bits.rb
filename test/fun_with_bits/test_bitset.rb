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

    def test_accessing_a_bit_that_is_set_returns_true
      bitset1 = Bitset.new(initial_value: 0b1000)
      bitset2 = Bitset.new(initial_value: 0b0100)
      bitset3 = Bitset.new(initial_value: 0b0010)
      bitset4 = Bitset.new(initial_value: 0b0001)

      assert_equal true, bitset1[3]
      assert_equal true, bitset2[2]
      assert_equal true, bitset3[1]
      assert_equal true, bitset4[0]
    end

    def test_accessing_a_bit_that_is_not_set_returns_false
      bitset1 = Bitset.new(initial_value: 0b0111)
      bitset2 = Bitset.new(initial_value: 0b1011)
      bitset3 = Bitset.new(initial_value: 0b1101)
      bitset4 = Bitset.new(initial_value: 0b1110)

      assert_equal false, bitset1[3]
      assert_equal false, bitset2[2]
      assert_equal false, bitset3[1]
      assert_equal false, bitset4[0]
    end

    def test_accessing_a_bit_that_is_out_of_bounds_returns_nil
      bitset = Bitset.new(initial_value: 0b1111, size: 4)

      assert_nil bitset[4]
    end

    def test_test_returns_true_if_the_bit_is_set
      bitset1 = Bitset.new(initial_value: 0b1000)
      bitset2 = Bitset.new(initial_value: 0b0100)
      bitset3 = Bitset.new(initial_value: 0b0010)
      bitset4 = Bitset.new(initial_value: 0b0001)

      assert_equal true, bitset1.test(3)
      assert_equal true, bitset2.test(2)
      assert_equal true, bitset3.test(1)
      assert_equal true, bitset4.test(0)
    end

    def test_test_returns_false_if_the_bit_is_not_set
      bitset1 = Bitset.new(initial_value: 0b0111)
      bitset2 = Bitset.new(initial_value: 0b1011)
      bitset3 = Bitset.new(initial_value: 0b1101)
      bitset4 = Bitset.new(initial_value: 0b1110)

      assert_equal false, bitset1.test(3)
      assert_equal false, bitset2.test(2)
      assert_equal false, bitset3.test(1)
      assert_equal false, bitset4.test(0)
    end

    def test_test_throws_out_of_range_error_if_index_is_out_of_bounds
      bitset = Bitset.new(initial_value: 0b1111, size: 4)

      error = assert_raises Bitset::OutOfRangeError do
        bitset.test(4)
      end

      assert_includes error.message, "index 4"
      assert_includes error.message, "size 4"
    end

    def test_size_returns_the_number_of_bits_that_the_bitset_holds
      bitset = Bitset.new(size: 18)

      assert_equal 18, bitset.size
    end
  end
end
