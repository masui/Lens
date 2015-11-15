# -*- ruby -*-

#
# Copyright (C) 2004 Toshiyuki MASUI <masui@pitecan.com>
#
# $Id: lens.rb,v 1.7 2004/02/17 08:35:43 masui Exp $
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
      message = Message.new # $BI8=`F~NO(B
      messages = [message]
      message.refile(@maildir) unless message.spam?(@config) # inbox$B$K%3%T!<(B
    else
      starttime = ParseDate.time(@arg)
      md = Maildir.new(@maildir)
      messages = md.find_all { |message|
	message.time >= starttime
      }
    end

    messages.each { |message|
      printf("%s Subject: %s \n",message.path,message.subject)

      # SPAM$BG'Dj%a!<%k$O(Bspam$B%U%)%k%@Aw$j(B
      if message.spam?(@config) then
	message.refile(@maildir,'00Spam')
	puts "   ==> spam"
	message.delete
	next
      end

      # SPAM$B0J30$O$9$Y$F(B2003/3$B$N$h$&$J%U%)%k%@$KJ]B8(B
      message.refile(@maildir,"#{message.time.year}/#{message.time.mon}")
      
      # $B7HBS$KE>Aw$9$k$+(B
      if @arg.nil? &&  @config[:mobile_address] && message.forward_to_mobile_phone?(@config) then
	Net::SMTP.start(@config[:smtp_host], 25) { |smtp|
	  smtp.send_mail(message.text,@config[:local_address],
			 @config[:mobile_address])
	}
      end

      # $BB>$N%"%I%l%9$KE>Aw$9$k$+(B
      if @arg.nil? &&  @config[:other_address] && message.forward_to_mobile_phone?(@config) then
	Net::SMTP.start(@config[:smtp_host], 25) { |smtp|
	  smtp.send_mail(message.text,@config[:local_address],
			 @config[:other_address])
	}
      end

      # $B%3%^%s%I%a!<%k=hM}(B
      if defined?(CommandMailHandler) && message.commandmail? then
	CommandMailHandler.new(message).process
      end

      # $B<+F/?6$jJ,$1(B
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
