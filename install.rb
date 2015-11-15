#!/usr/bin/env ruby
# -*- ruby -*-

# Copyright (C) 2004 Toshiyuki MASUI <masui@pitecan.com>
#
# $Id: install.rb,v 1.2 2004/02/17 06:48:22 masui Exp $
#
# This program 'Towers of Hanoi by TeX' is free software; you can
# redistribute it and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation; either
# version 2 or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

require 'rbconfig'

home = ENV['HOME']
bindir = ARGV.shift
sitelibdir = Config::CONFIG['sitelibdir']
lenslibdir = "#{sitelibdir}/lens"

LIBFILES = [
  'lens.rb',
  'maildir.rb',
  'message.rb',
  'parsedate.rb',
  'classify.rb',
]

Dir.mkdir(lenslibdir) if ! File.exist?(lenslibdir)
LIBFILES.each { |libfile|
  puts "cp -f #{libfile} #{lenslibdir}"
  system "cp -f #{libfile} #{lenslibdir}"
}

puts "cp -f lens #{bindir}"
system "cp -f lens #{bindir}"

lensrc = "#{home}/.lensrc"
if !File.exist?(lensrc) then
  puts "cp lensrc.sample #{lensrc}"
  system "cp lensrc.sample #{lensrc}"
end

commandmailrc = "#{home}/.commandmailrc"
if !File.exist?(commandmailrc) then
  puts "cp commandmailrc.sample #{commandmailrc}"
  system "cp commandmailrc.sample #{commandmailrc}"
end
