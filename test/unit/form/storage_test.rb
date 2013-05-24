# encoding: utf-8

require "test_helper"

class Cleartape::Form::StorageTest < Cleartape::TestCase

  context "Cleartape::Form::Storage" do
    should "persist data" do
      storage = Cleartape::Form::Storage.new(form)
      storage[:foo] = 1
      storage.data.merge!(:bar => 2)

      assert_equal 1, storage[:foo]
      assert_equal 2, storage[:bar]
      assert_equal 1, Cleartape::Form::Storage.new(form).data[:foo]
      assert_equal 2, Cleartape::Form::Storage.new(form).data[:bar]
    end
  end

end
