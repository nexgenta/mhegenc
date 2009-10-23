#  Simple makefile for mhegenc.
CC = gcc
LD = gcc
YACC = bison
LEX = flex
#SNACC = snacc
TAR = tar

VERSION_MAJOR := 0
VERSION_MINOR := 12

UNAME := $(shell uname)

CFLAGS= -I./src -DUSE_EXP_BUF \
        -DVERSION_MAJOR=$(VERSION_MAJOR) -DVERSION_MINOR=$(VERSION_MINOR) -O2

LFLAGS= 

ifeq (${UNAME},CYGWIN_NT-5.1)	# Cygwin Platform ======
CFLAGS += -mno-cygwin
LFLAGS += -mno-cygwin
endif

SRCFILES = 	src/mh_print.c src/mh_snacc.c src/mh_snacc.h \
		src/mheg.y src/mheg.lex src/main.c src/diag.c src/diag.h \
		src/lexer.h src/parser.h \
		src/asn-any.h src/asn-bits.h src/asn-bool.h src/asn-config.h \
		src/asn-enum.h src/asn-incl.h src/asn-int.h src/asn-len.h \
		src/asn-list.h src/asn-null.h src/asn-octs.h src/asn-oid.h \
		src/asn-real.h src/asn-tag.h src/asn-useful.h src/config.h \
		src/exp-buf.h src/hash.h src/nibble-alloc.h src/policy.h \
		src/print.h src/snacc.h \
		src/asn-any.c src/asn-bits.c src/asn-bool.c \
		src/asn-enum.c src/asn-int.c src/asn-len.c \
		src/asn-list.c src/asn-null.c src/asn-octs.c src/asn-oid.c \
		src/asn-real.c src/asn-tag.c src/asn-useful.c \
		src/exp-buf.c src/hash.c src/nibble-alloc.c \
		src/print.c src/str-stk.h src/str-stk.c src/gen-buf.h 

DISTFILES = 	Makefile README EXTENSIONS INSTRUCTIONS LICENCE $(SRCFILES) \
                src/uk.inc src/nz.inc mhegtest.py runtests.py
DISTFILES += 	testfiles

DIST_ARCHIVE = mhegenc-$(VERSION_MAJOR).$(VERSION_MINOR).tar.gz
OBJS = main lex.yy mheg.tab mh_snacc mh_print diag \
	asn-any asn-bits asn-bool asn-enum asn-int asn-len \
	asn-list asn-null asn-octs asn-oid asn-real asn-tag asn-useful \
	exp-buf hash nibble-alloc print str-stk

BINDIR = bin/${UNAME}
OBJDIR = obj/${UNAME}
OBJFILES = $(addsuffix .o, $(addprefix $(OBJDIR)/, $(OBJS)))

all: mhegenc

.PHONY:
mhegenc: $(BINDIR)/mhegenc


$(BINDIR)/mhegenc: $(OBJFILES)
	mkdir -p $(BINDIR)
	$(LD) -o $@ $^ $(LFLAGS) 

lextest: $(OBJDIR)/lex.yy.o
	$(LD) -o $@ $^ -lfl

$(OBJDIR)/mh_snacc.o: src/mh_snacc.c Makefile
	mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -o $@ -c $<

$(OBJDIR)/%.o: src/%.c Makefile
	mkdir -p $(OBJDIR)
	$(CC) $(CFLAGS) -Wall -o $@ -c $<

src/lex.yy.c: src/mheg.lex Makefile src/mheg.tab.h 
	$(LEX) -o$@ -i $<

src/mheg.tab.c src/mheg.tab.h: src/mheg.y Makefile src/mh_snacc.h
	cd $(<D); $(YACC) --debug --verbose --defines $(<F)

clean:
	rm -f $(OBJFILES) $(BINDIR)/mhegenc src/lex.yy.c src/mheg.tab.c src/mheg.tab.h src/mheg.output

dist: $(DIST_ARCHIVE)

$(DIST_ARCHIVE): $(DISTFILES)
	cd ..; $(TAR) -cvzf mhegenc/$@ $(addprefix mhegenc/, $^)

.PHONY: test
test: mhegenc
	export PATH=$(BINDIR):$$PATH; python runtests.py

.PHONY: tags
tags: TAGS

TAGS: $(SRCFILES)
	etags $(SRCFILES)

#mh_snacc.c mh_snacc.h: mh_snacc.asn Makefile
#	$(SNACC) $<

#depend: $(patsubst %.o, %.d, $(OBJFILES))

#$(patsubst %.o, %.d, $(OBJFILES)):  %.d: %.c
#	$(CC) $(CFLAGS) -o $@ -M $<
