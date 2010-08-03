AC_INIT(mhegenc,0.13)
AC_CONFIG_SRCDIR(src/main.c)
AM_INIT_AUTOMAKE(foreign)
AM_MAINTAINER_MODE

AC_PROG_CC
AC_PROG_LIBTOOL
AC_PROG_YACC
AC_PROG_LEX

AC_DEFINE_UNQUOTED(VERSION_MAJOR, 0, [Major version number])
AC_DEFINE_UNQUOTED(VERSION_MINOR, 13, [Minor version number])

AC_ARG_WITH([snacc],[AS_HELP_STRING([--with-snacc=DIR],[specify snacc installation prefix])],[snacc_config="$withval/bin/snacc-config"],[snacc_config=""])

if test x"$snacc_config" = x"" ; then
	PKG_CHECK_MODULES([snacc],[snacc-c-ebuf >= 1.3],[
		SNACC_CPPFLAGS="$snacc_CFLAGS"
		SNACC_LIBS="$snacc_LIBS"
	],[snacc_config="snacc-config"])
fi

if test x"$snacc_config" = x"" ; then
	true
else
	AC_MSG_CHECKING([for snacc])
	snacc_version=`$snacc_config --version`
	if test x"$snacc_version" = x"" ; then
		AC_MSG_ERROR([could not locate snacc; try --with-snacc=PREFIX or setting PKG_CONFIG_PATH])
	fi
	SNACC_CPPFLAGS="`$snacc_config --cflags ebuf`"
	SNACC_LIBS="`$snacc_config --libs ebuf`"
	AC_MSG_RESULT([$snacc_version])
fi

AC_SUBST([SNACC_CPPFLAGS])
AC_SUBST([SNACC_LIBS])

AC_CONFIG_FILES([Makefile
src/Makefile
])

AC_OUTPUT

