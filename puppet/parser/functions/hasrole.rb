#
# hasrole.rb
#

module Puppet::Parser::Functions
  newfunction(:hasrole, :type => :rvalue, :doc => <<-EOS
This function determines if a role is part of a list encoded as a string.

*Examples:*
    hasrole("['nn', 'jt']", 'nn')

Would return: true

    hasrole("['nn', 'jt']", 'client')

Would return: false
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "hasrole(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array = eval(arguments[0])

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'hasrole(): Requires array to work with')
    end

    item = arguments[1]

    raise(Puppet::ParseError, 'hasrole(): You must provide item ' +
      'to search for within array given') if item.empty?

    return array.include?(item)
  end
end
