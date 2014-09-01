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

    OPTION_RE = /(\w+)__(\w+)(\?)?\z/

    SWITCH_RE = /(\w+)(\?)?\z/

    KEY_POOL = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a

    def keys
      { used: keys = top.short.keys, free: KEY_POOL - keys }
    end

    def separator(string = '')
      super
    end

    # Delegates to #on with some convenience shortcuts.
    #
    # If +name+ is a Symbol, installs both long and short options.
    # If the first element of +args+ is a Symbol, this is installed
    # as the short option, otherwise the first character of +name+ is
    # installed as the short option.
    #
    # If +name+ is a String, installs only the long option.
    #
    # If +name+ contains an argument name, separated by double underscore,
    # additionally sets the CLI's +name+ option (as a Symbol) to the
    # provided value and calls the optional block with that value. If
    # the argument name ends with a question mark, the value is marked
    # as optional.
    def option(name, *args, &block)
      sym = name.is_a?(Symbol)

      if name =~ OPTION_RE
        name, arg, opt = $1, $2, !!$3
        __on_opts(name, args, sym)

        arg = "[#{arg}]" if opt
        args.grep(/\A--/).first << " #{arg}"

        on(*args) { |value|
          cli.options[name.to_sym] = value
          yield value if block_given?
        }
      else
        on(*__on_opts(name, args, sym), &block)
      end
    end

    # Delegates to #on with some convenience shortcuts.
    #
    # If +name+ is a Symbol, installs both long and short options.
    # If the first element of +args+ is a Symbol, this is installed
    # as the short option, otherwise the first character of +name+ is
    # installed as the short option.
    #
    # If +name+ is a String, installs only the long option.
    #
    # Sets the CLI's +name+ option (as a Symbol) to +true+ and calls
    # the optional block (with no argument).
    #
    # If +name+ ends with a question mark, installs only the long option
    # and sets the CLI's +name+ option (as a Symbol) to either +true+ or
    # +false+, depending on whether <tt>--name</tt> or <tt>--no-name</tt>
    # was given on the command line.
    def switch(name, *args)
      sym = name.is_a?(Symbol)

      name, opt = $1, !!$2 if name =~ SWITCH_RE

      if opt
        __on_opts(name, args, false)
        args.first.insert(2, '[no-]')

        on(*args) { |value|
          cli.options[name.to_sym] = value
          yield if block_given?
        }
      else
        on(*__on_opts(name, args, sym)) {
          cli.options[name.to_sym] = true
          yield if block_given?
        }
      end
    end

    private

    def __on_opts(name, args, sym)
      args.insert(0, "-#{args[0].is_a?(Symbol) ? args.shift : name[0]}") if sym
      args.insert(sym ? 1 : 0, "--#{name.to_s.tr('_', '-')}")
    end

  end

end
