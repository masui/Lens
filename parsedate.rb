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

require 'time'

module ParseDate # time('3/11') time('Thu Mar 11 19:28:23 JST 1999')
  def time(date, cyear=false)
    # ary = parsedate(date, cyear)
    # now = Time.now
    # nowary = [now.year, now.mon, now.mday, now.hour, now.min, now.sec]
    # (0..5).each { |i|
    #   ary[i] = nowary[i] if ary[i].nil?
    #  }
    #  ary[6] == 'GMT' ? Time::gm(*ary[0..5]) : Time::local(*ary[0..5])

    t = (date.to_s == '' ? Time.now : Time.parse(date))
    # ary = [t.year, t.month, t.day, t.hour, t.min, t.sec, t]
  end
  module_function :time
end

