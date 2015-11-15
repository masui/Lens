#
#	$Date: 2004/02/12 05:44:31 $
#	$Revision: 1.12 $
#
# make$B$r5/F0$9$k$H!"I,MW$J%i%$%V%i%j$,(B/usr/local/lib/ruby/site_ruby/1.x $B$J$I$K!"(B
# lens$B%W%m%0%i%`$,(B /usr/local/bin/ $B$J$I$K!"(B
# lensrc.sample$B$,(B ~/.lensrc $B$K!"(B
# commandmailrc.sample$B$,(B ~/.commandmailrc $B$K(B $B%3%T!<$5$l$k!#(B
#

# lens$B%W%m%0%i%`$r%$%s%9%H!<%k$9$k%G%#%l%/%H%j(B
BINDIR = /usr/local/bin

VERSION = 0.2

INSTALLFILES = \
	lens.rb \
	maildir.rb \
	message.rb \
	parsedate.rb \
	classify.rb

BINFILES = lens \
	install.rb

TESTFILES =  \
	test/maildir_test \
	test/message_test \
	test/classify_test

RCFILES = commandmailrc.sample \
	lensrc.sample

FILES = $(INSTALLFILES) \
	$(BINFILES) \
	$(TESTFILES) \
	$(RCFILES) \
	Makefile \
	index.html

install:
	ruby install.rb $(BINDIR)
clean:
	rm -f *~

TMPDIR = lens-$(VERSION)

tar:
	mkdir $(TMPDIR)
	tar cf - $(FILES) | (cd $(TMPDIR); tar xf -)
	tar czf lens-$(VERSION).tar.gz $(TMPDIR)
	rm -r -f $(TMPDIR)

libtest:	
	ruby test/maildir_test
	ruby test/message_test
	ruby test/classify_test

mailtest:
	ruby lens < test/madoka.mail
	ruby lens < test/schedule.mail
	ruby lens < test/spam.mail
	ruby lens < test/spam2.mail

