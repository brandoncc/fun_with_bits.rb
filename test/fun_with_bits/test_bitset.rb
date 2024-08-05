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

    def test_all_returns_true_if_all_bits_are_set
      bitset = Bitset.new(size: 4, initial_value: 0b1111)

      assert_equal true, bitset.all?
    end

    def test_all_returns_false_if_all_bits_are_not_set
      bitset1 = Bitset.new(size: 4, initial_value: 0b0111)
      bitset2 = Bitset.new(size: 8, initial_value: 0b1111)

      assert_equal false, bitset1.all?
      assert_equal false, bitset2.all?
    end

    def test_any_returns_true_if_any_bits_are_set
      bitset1 = Bitset.new(initial_value: 0b100, size: 3)
      bitset2 = Bitset.new(initial_value: 0b010, size: 3)
      bitset3 = Bitset.new(initial_value: 0b001, size: 3)

      assert_equal true, bitset1.any?
      assert_equal true, bitset2.any?
      assert_equal true, bitset3.any?
    end

    def test_any_returns_false_if_no_bits_are_set
      bitset = Bitset.new(initial_value: 0b0)

      assert_equal false, bitset.any?
    end

    def test_none_returns_true_if_no_bits_are_set
      bitset = Bitset.new(initial_value: 0b0)

      assert_equal true, bitset.none?
    end

    def test_none_returns_false_if_any_bits_are_set
      bitset1 = Bitset.new(initial_value: 0b100, size: 3)
      bitset2 = Bitset.new(initial_value: 0b010, size: 3)
      bitset3 = Bitset.new(initial_value: 0b001, size: 3)

      assert_equal false, bitset1.none?
      assert_equal false, bitset2.none?
      assert_equal false, bitset3.none?
    end

    def test_count_returns_the_number_of_bits_that_are_set_to_true
      bitset1 = Bitset.new(initial_value: 0b0000, size: 4)
      bitset2 = Bitset.new(initial_value: 0b0010, size: 4)
      bitset3 = Bitset.new(initial_value: 0b1010, size: 4)
      bitset4 = Bitset.new(initial_value: 0b1111, size: 4)

      assert_equal 0, bitset1.count
      assert_equal 1, bitset2.count
      assert_equal 2, bitset3.count
      assert_equal 4, bitset4.count
    end

    def test_size_returns_the_number_of_bits_that_the_bitset_holds
      bitset = Bitset.new(size: 18)

      assert_equal 18, bitset.size
    end

    def test_and_bang_modifies_the_set_using_binary_and
      bitset1 = Bitset.new(initial_value: 0b1001, size: 4)
      bitset2 = Bitset.new(initial_value: 0b1010, size: 4)

      bitset1.and!(bitset2)

      assert_equal false, bitset1[0]
      assert_equal false, bitset1[1]
      assert_equal false, bitset1[2]
      assert_equal true, bitset1[3]
    end

    def test_and_bang_raises_if_bitsets_have_different_sizes
      bitset1 = Bitset.new(size: 4)
      bitset2 = Bitset.new(size: 8)

      assert_raises Bitset::SetsMustHaveSameSizeError do
        bitset1.and!(bitset2)
      end
    end

    def test_or_bang_modifies_the_set_using_binary_or
      bitset1 = Bitset.new(initial_value: 0b1001, size: 4)
      bitset2 = Bitset.new(initial_value: 0b1010, size: 4)

      bitset1.or!(bitset2)

      assert_equal true, bitset1[0]
      assert_equal true, bitset1[1]
      assert_equal false, bitset1[2]
      assert_equal true, bitset1[3]
    end

    def test_or_bang_raises_if_bitsets_have_different_sizes
      bitset1 = Bitset.new(size: 4)
      bitset2 = Bitset.new(size: 8)

      assert_raises Bitset::SetsMustHaveSameSizeError do
        bitset1.or!(bitset2)
      end
    end

    def test_xor_bang_modifies_the_set_using_binary_xor
      bitset1 = Bitset.new(initial_value: 0b1001, size: 4)
      bitset2 = Bitset.new(initial_value: 0b1010, size: 4)

      bitset1.xor!(bitset2)

      assert_equal true, bitset1[0]
      assert_equal true, bitset1[1]
      assert_equal false, bitset1[2]
      assert_equal false, bitset1[3]
    end

    def test_xor_bang_raises_if_bitsets_have_different_sizes
      bitset1 = Bitset.new(size: 4)
      bitset2 = Bitset.new(size: 8)

      assert_raises Bitset::SetsMustHaveSameSizeError do
        bitset1.xor!(bitset2)
      end
    end

    def test_tilde_returns_a_new_instance_with_all_bits_flipped # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      bitset = Bitset.new(initial_value: 0b1010, size: 5)

      flipped_bitset = ~bitset

      assert_equal false, bitset[0]
      assert_equal true, bitset[1]
      assert_equal false, bitset[2]
      assert_equal true, bitset[3]
      assert_equal false, bitset[4]

      assert_equal true, flipped_bitset[0]
      assert_equal false, flipped_bitset[1]
      assert_equal true, flipped_bitset[2]
      assert_equal false, flipped_bitset[3]
      assert_equal true, flipped_bitset[4]
    end

    def test_set_with_argument_sets_the_specified_bit_to_true
      bitset = Bitset.new
      assert_equal false, bitset[3]

      bitset.set(3)
      assert_equal true, bitset[3]
    end

    def test_set_with_argument_does_not_set_unspecified_bits_to_true
      bitset = Bitset.new(initial_value: 0b0, size: 4)

      bitset.set(3)

      assert_equal false, bitset[0]
      assert_equal false, bitset[1]
      assert_equal false, bitset[2]
    end

    def test_set_without_argument_sets_all_bits_to_true
      bitset = Bitset.new(initial_value: 0b0, size: 4)
      refute bitset.all?

      bitset.set
      assert bitset.all?
    end

    def test_set_throws_out_of_range_error_if_index_is_out_of_bounds
      bitset = Bitset.new(initial_value: 0b1111, size: 4)

      error = assert_raises Bitset::OutOfRangeError do
        bitset.set(4)
      end

      assert_includes error.message, "index 4"
      assert_includes error.message, "size 4"
    end

    def test_reset_with_argument_sets_the_specified_bit_to_false
      bitset = Bitset.new(initial_value: 0b1111)

      bitset.reset(3)

      assert_equal false, bitset[3]
    end

    def test_reset_without_argument_sets_all_bits_to_false
      bitset = Bitset.new(initial_value: 0b1111)

      bitset.reset

      assert_equal false, bitset[0]
      assert_equal false, bitset[1]
      assert_equal false, bitset[2]
      assert_equal false, bitset[3]
    end

    def test_reset_throws_out_of_range_error_if_index_is_out_of_bounds
      bitset = Bitset.new(initial_value: 0b1111, size: 4)

      error = assert_raises Bitset::OutOfRangeError do
        bitset.reset(4)
      end

      assert_includes error.message, "index 4"
      assert_includes error.message, "size 4"
    end

    def test_flip_with_argument_modifies_the_set_by_flipping_the_specified_bit
      bitset = Bitset.new(initial_value: 0b01)

      bitset.flip(0)

      assert_equal false, bitset[0]
      assert_equal false, bitset[1]

      bitset.flip(1)

      assert_equal false, bitset[0]
      assert_equal true, bitset[1]
    end

    def test_flip_without_argument_modifies_the_set_by_flipping_all_bits
      bitset = Bitset.new(initial_value: 0b1, size: 2)

      bitset.flip

      assert_equal false, bitset[0]
      assert_equal true, bitset[1]
    end

    def test_flip_throws_out_of_range_error_if_index_is_out_of_bounds
      bitset = Bitset.new(initial_value: 0b1111, size: 4)

      error = assert_raises Bitset::OutOfRangeError do
        bitset.flip(4)
      end

      assert_includes error.message, "index 4"
      assert_includes error.message, "size 4"
    end

    def test_to_i_returns_a_numeric_representation_of_the_data
      bitset = Bitset.new(initial_value: 0b111)

      assert_equal 7, bitset.to_i
    end
  end
end
