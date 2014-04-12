#--
###############################################################################
#                                                                             #
# cyclops -- A command-line option parser                                     #
#                                                                             #
# Copyright (C) 2014 Jens Wille                                               #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# cyclops is free software; you can redistribute it and/or modify it under    #
# the terms of the GNU Affero General Public License as published by the Free #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# cyclops is distributed in the hope that it will be useful, but WITHOUT ANY  #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for     #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with cyclops. If not, see <http://www.gnu.org/licenses/>.             #
#                                                                             #
###############################################################################
#++

class Cyclops

  module OptionParserExtension

    attr_accessor :cli

    KEY_POOL = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a

    def keys
      { :used => keys = top.short.keys, :free => KEY_POOL - keys }
    end

    def separator(string = '')
      super
    end

    def option(name, *args, &block)
      if name =~ /(\w+)__(\w+)(\?)?\z/
        sym = name.is_a?(Symbol)

        name, arg, opt = $1, $2, !!$3
        name = name.to_sym if sym

        args = __on_opts(name, *args)

        arg = "[#{arg}]" if opt
        args.grep(/\A--/).first << " #{arg}"

        on(*args) { |value|
          cli.options[name] = value
          yield value if block_given?
        }
      else
        on(*__on_opts(name, *args), &block)
      end
    end

    def switch(name, *args)
      on(*__on_opts(name, *args)) {
        cli.options[name] = true
        yield if block_given?
      }
    end

    private

    def __on_opts(name, *args)
      case name
        when Symbol
          long = "--#{name.to_s.tr('_', '-')}"

          args.unshift(args.first.is_a?(Symbol) ?
            "-#{args.shift}" : long[1, 2], long)
        when String
          args.unshift("--#{name}")
        else
          args.unshift(name)
      end
    end

  end

end
