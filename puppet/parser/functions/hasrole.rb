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

  newfunction(:islastslave, :type => :rvalue, :doc => <<-EOS
This function determines if a node is the last slave. The first parameter
is the node map and the second is the hostname.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "islastslave(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    nodes = eval(arguments[0])

    unless nodes.is_a?(Array)
      raise(Puppet::ParseError, 'islastslave(): Requires array to work with')
    end

    host = arguments[1]

    raise(Puppet::ParseError, 'islastslave(): You must provide item ' +
      'to search for within array given') if host.empty?

    slaves = nodes.select {|node| node[:roles].include? 'slave'}.
      map{|node| node[:hostname]}
    return slaves.last == host
  end
end
