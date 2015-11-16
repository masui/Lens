# -*- coding: utf-8 -*-
# -*- ruby -*-

# Copyright (C) 2004-2015 Toshiyuki MASUI <masui@pitecan.com>
#
# This program 'Lens' is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

require 'net/smtp'
require 'parsedate'

require 'lens/maildir'
require 'lens/message'
require 'lens/classify'
require 'lens/parsedate'

class Lens
  def initialize(config,arg)
    @config = config
    @arg = arg
    @maildir = @config[:maildir]
  end

  def process
    if @arg.nil?
      message = Message.new # 標準入力
      messages = [message]
      message.refile(@maildir) unless message.spam?(@config) # inboxにコピー
    else
      starttime = ParseDate.time(@arg)
      md = Maildir.new(@maildir)
      messages = md.find_all { |message|
	message.time >= starttime
      }
    end

    messages.each { |message|
      printf("%s Subject: %s \n",message.path,message.subject)

      # SPAM認定メールはspamフォルダ送り
      if message.spam?(@config) then
	message.refile(@maildir,'00Spam')
	puts "   ==> spam"
	message.delete
	next
      end

      # SPAM以外はすべて2003/3のようなフォルダに保存
      message.refile(@maildir,"#{message.time.year}/#{message.time.mon}")
      
      # 携帯に転送するか
      if @arg.nil? &&  @config[:mobile_address] && message.forward_to_mobile_phone?(@config) then
	Net::SMTP.start(@config[:smtp_host], 25) { |smtp|
	  smtp.send_mail(message.text,@config[:local_address],
			 @config[:mobile_address])
	}
      end

      # 他のアドレスに転送するか
      if @arg.nil? &&  @config[:other_address] && message.forward_to_mobile_phone?(@config) then
	Net::SMTP.start(@config[:smtp_host], 25) { |smtp|
	  smtp.send_mail(message.text,@config[:local_address],
			 @config[:other_address])
	}
      end

      # コマンドメール処理
      if defined?(CommandMailHandler) && message.commandmail? then
	CommandMailHandler.new(message).process
      end

      # 自働振り分け
      if folders = message.refile_folders(@config) then
	folders.each { |folder|
	  message.refile(@maildir,folder)
	  puts "   +=> #{folder}"
	}
	if message.not_important?(@config) then
	  message.delete
	end
      end

      message.delete if message.stdin
    }
  end
end
