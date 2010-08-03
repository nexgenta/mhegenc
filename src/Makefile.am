bin_PROGRAMS = mhegenc

mhegenc_SOURCES = mh_print.c mh_snacc.c mh_snacc.h mheg.y \
	mheg-lexer.l main.c diag.c diag.h lexer.h parser.h

mhegenc_CPPFLAGS = $(SNACC_CPPFLAGS)
mhegenc_LDADD = $(SNACC_LIBS)
