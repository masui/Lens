#
#	$Date: 2004/02/12 05:44:31 $
#	$Revision: 1.12 $
#
# makeを起動すると、必要なライブラリが/usr/local/lib/ruby/site_ruby/1.x などに、
# lensプログラムが /usr/local/bin/ などに、
# lensrc.sampleが ~/.lensrc に、
# commandmailrc.sampleが ~/.commandmailrc に コピーされる。
#
#  2015/11/16 10:38:41 新しいpirecan.comで動かすための修正開始
#

# lensプログラムをインストールするディレクトリ
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
	ruby test/parsedate_test

mailtest:
	ruby lens < test/madoka.mail
	ruby lens < test/schedule.mail
	ruby lens < test/spam.mail
	ruby lens < test/spam2.mail

