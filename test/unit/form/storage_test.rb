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

    should "not overwrite model params" do
      storage = Cleartape::Form::Storage.new(form)
      storage.update(form.form_name => { :model => { :attribute_1 => 1 } })
      storage.update(form.form_name => { :model => { :attribute_2 => 2 } })

      assert_equal 1, storage[:model][:attribute_1]
      assert_equal 2, storage[:model][:attribute_2]
    end
  end

end
