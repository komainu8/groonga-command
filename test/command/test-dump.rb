# -*- coding: utf-8 -*-
#
# Copyright (C) 2013-2016  Kouhei Sutou <kou@clear-code.com>
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

class DumpCommandTest < Test::Unit::TestCase
  private
  def dump_command(pair_arguments={}, ordered_arguments=[])
    Groonga::Command::Dump.new("dump", pair_arguments, ordered_arguments)
  end

  class ConstructorTest < self
    def test_ordered_arguments
      tables       = "Users, Logs"
      dump_plugins = "no"
      dump_schema  = "yes"
      dump_records = "no"
      dump_indexes = "yes"
      dump_confs   = "no"

      command = dump_command({},
                             [
                               tables,
                               dump_plugins,
                               dump_schema,
                               dump_records,
                               dump_indexes,
                               dump_confs,
                             ])
      assert_equal({
                     :tables       => tables,
                     :dump_plugins => dump_plugins,
                     :dump_schema  => dump_schema,
                     :dump_records => dump_records,
                     :dump_indexes => dump_indexes,
                     :dump_confs   => dump_confs,
                   },
                   command.arguments)
    end
  end

  class OutputTypeTest < self
    def test_none
      assert_equal(:none, dump_command.output_type)
    end
  end
end
