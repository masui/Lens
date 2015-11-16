# -*- coding: utf-8 -*-

# Copyright (C) 2004 Toshiyuki MASUI <masui@pitecan.com>
#
# $Id: message.rb,v 1.7 2004/02/17 06:48:22 masui Exp $
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

# require 'mailread'
# require 'kconv'

require 'mail'
require 'socket' # for hostname

require 'lens/parsedate'
require 'lens/maildir'

class Message
  def initialize(path = nil)
    if path.nil? then # 標準入力からメッセージ読み込み
      hostname = Socket.gethostname
      @stdin = true
      @text = STDIN.readlines
      date = @text.grep(/^Date:/)[0]
      time = date ? ParseDate.time(date) : Time.now
      @path = "/tmp/#{time.to_i}.#{$$}.#{hostname}"
      File.open(@path,"w"){ |f|
	f.print @text
      }
    else
      @path = path
      @stdin = false
      File.open(@path,"r"){ |f|
	@text = f.readlines
      }
    end
    @mail = Mail.read(@path)
  end

  attr :path, true
  attr :text, true
  attr :stdin, true

  def refile(maildir, folder = nil)
    md = Maildir.new(maildir, folder)
    refilepath = md.messagepath(@path)
    if !test(?f,refilepath) then
      # File.link(@path,refilepath)
      system "cp #{@path} #{refilepath}"
    end
  end

  def delete
    File.delete(@path)
  end

  def [](entry)
    @mail[entry].to_s
  end

  def subject
    self['Subject'].gsub(/[\r\n]+/,'')
  end

  def body
    @mail.body
  end

  def header
    @mail.header
  end

  def time
    self['Date'] ? ParseDate.time(self['Date']) : File.stat(@path).mtime
  end

  def ml_name
    subject =~ /\[([\d\w\-_]+):\d*\]/
    $1
  end
end
