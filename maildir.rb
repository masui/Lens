# -*- ruby -*-

# Copyright (C) 2004 Toshiyuki MASUI <masui@pitecan.com>
#
# $Id: maildir.rb,v 1.3 2004/02/17 06:48:22 masui Exp $
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
# Maildir形式のファイルを操作
#

require 'lens/message'

class Maildir
  def initialize(maildir, folder = nil)
    @folderdir = (folder ? "#{maildir}/.#{folder.gsub('/','.')}" : maildir)
    if !test(?d,@folderdir) then
      Dir.mkdir(@folderdir)
      Dir.mkdir("#{@folderdir}/cur")
      Dir.mkdir("#{@folderdir}/new")
      Dir.mkdir("#{@folderdir}/tmp")
    end
    @curdir = Dir.new("#{@folderdir}/cur")
  end

  def messagepath(path)
    "#{@folderdir}/cur/#{File.basename(path)}"
  end

  def each
    @curdir.each { |file|
      path = messagepath(file)
      if test(?f,path) then
	message = Message.new(path)
	yield message
      end
    }
  end
end

