# -*- coding: utf-8 -*-
#
# Copyright (C) 2012-2014  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

class TableCreateCommandTest < Test::Unit::TestCase
  private
  def table_create_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::TableCreate.new("table_create",
                                      pair_arguments,
                                      ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      name              = "Users"
      flags             = "TABLE_PAT_KEY"
      key_type          = "ShortText"
      value_type        = "UInt32"
      default_tokenizer = "TokenBigram"
      normalizer        = "NormalizerAuto"

      ordered_arguments = [
        name,
        flags,
        key_type,
        value_type,
        default_tokenizer,
        normalizer,
      ]
      command = table_create_command({}, ordered_arguments)
      assert_equal({
                     :name              => name,
                     :flags             => flags,
                     :key_type          => key_type,
                     :value_type        => value_type,
                     :default_tokenizer => default_tokenizer,
                     :normalizer        => normalizer,
                   },
                   command.arguments)
    end
  end

  class KeyTypeTest < self
    def test_specified
      command = table_create_command({"key_type" => "ShortText"})
      assert_equal("ShortText", command.key_type)
    end

    def test_omitted
      command = table_create_command
      assert_nil(command.key_type)
    end
  end

  class FlagsTest < self
    def test_multiple
      command = table_create_command({"flags" => "TABLE_PAT_KEY|KEY_WITH_SIS"})
      assert_equal(["TABLE_PAT_KEY", "KEY_WITH_SIS"],
                   command.flags)
    end

    def test_one
      command = table_create_command({"flags" => "TABLE_NO_KEY"})
      assert_equal(["TABLE_NO_KEY"],
                   command.flags)
    end

    def test_no_flags
      command = table_create_command
      assert_equal([], command.flags)
    end

    class PredicateTest < self
      data({
             "TABLE_NO_KEY" => {
               :expected => true,
               :flags    => "TABLE_NO_KEY",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "TABLE_HASH_KEY",
             }
           })
      def test_table_no_key?(data)
        command = table_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.table_no_key?)
      end

      data({
             "TABLE_HASH_KEY" => {
               :expected => true,
               :flags    => "TABLE_HASH_KEY",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "TABLE_PAT_KEY",
             }
           })
      def test_table_hash_key?(data)
        command = table_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.table_hash_key?)
      end

      data({
             "TABLE_PAT_KEY" => {
               :expected => true,
               :flags    => "TABLE_PAT_KEY",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "TABLE_DAT_KEY",
             }
           })
      def test_table_pat_key?(data)
        command = table_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.table_pat_key?)
      end

      data({
             "TABLE_DAT_KEY" => {
               :expected => true,
               :flags    => "TABLE_DAT_KEY",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "TABLE_NO_KEY",
             }
           })
      def test_table_dat_key?(data)
        command = table_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.table_dat_key?)
      end

      data({
             "KEY_WITH_SIS" => {
               :expected => true,
               :flags    => "KEY_WITH_SIS|TABLE_PAT_KEY",
             },
             "other flag"   => {
               :expected => false,
               :flags    => "TABLE_NO_KEY",
             }
           })
      def test_key_with_sis?(data)
        command = table_create_command({"flags" => data[:flags]})
        assert_equal(data[:expected], command.key_with_sis?)
      end
    end
  end
end
