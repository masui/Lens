# -*- coding: utf-8 -*-
# -*- ruby -*-

# Copyright (C) 2004 Toshiyuki MASUI <masui@pitecan.com>
#
# $Id: classify.rb,v 1.6 2004/02/17 06:48:22 masui Exp $
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

require 'lens/message'

class Message
  def sobigf?
    self['Content-Type'] =~ /multipart/i &&
      subject =~ /(Your application|Details|Thank you!|That movie|Wicked screensaver|Your details|Approved|My details)/
  end

  def spam_contents?
    # 内容からのSPAM判定ルーチンがあればここに記述する。.lensrc内で spam_contents? を定義してもよい。
    # system "/home/masui/bin/bsfilter -m rf --homedir /home/masui/SpamFilter/.bsfilter < #{path}"
    false
  end

  def have_spam_pat?(config)
    config[:spam_patterns].find { |entry,patterns|
      patterns.find { |pattern|
	self[entry] =~ pattern
      }
    }
  end

  def spam?(config)
    sobigf? || spam_contents? || have_spam_pat?(config)
  end

  def not_important?(config)
    config[:non_important_mls][ml_name]
  end

  def forward_to_mobile_phone?(config)
    !spam?(config) && !not_important?(config)
  end

  def refile_folders(config)
    config[:subject_patterns].find_all { |pat,folder|
      Regexp.new(pat,true).match(subject)
    }.collect { |key,val| val } |
    config[:from_patterns].find_all { |pat,folder|
      Regexp.new(pat,true).match(self['From']) ||
	Regexp.new(pat,true).match(self['To']) ||
	Regexp.new(pat,true).match(self['Cc'])
    }.collect { |key,val| val }.flatten |
      (ml_name ? [ml_name] : [])
  end

  def commandmail?
    subject =~ /^\S+[\+\?!]$/
  end
end
