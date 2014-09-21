#
# Testing rules for make
# Originally copied from JSON-GLib project
#
# test: run all tests in cwd and subdirs
# test-report: run tests in subdirs and generate report
# perf-report: run tests in subdirs with -m perf and generate report
# full-report: like test-report: with -m perf and -m slow
#

GTESTER        = gtester
GTESTER_REPORT = gtester-report

# initialize variables for unconditional += appending
EXTRA_DIST =
TEST_PROGS =

### testing rules

# test: run all tests in cwd and subdirs
test: test-nonrecursive
	@for subdir in $(SUBDIRS) . ; do \
	  test "$$subdir" = "." -o "$$subdir" = "po" || \
	  ( cd $$subdir && $(MAKE) $(AM_MAKEFLAGS) $@ ) || exit $? ; \
	done

# test-nonrecursive: run tests only in cwd
test-nonrecursive: ${TEST_PROGS}
	@test -z "${TEST_PROGS}" || ${GTESTER} --verbose ${TEST_PROGS}

# test-report: run tests in subdirs and generate report
# perf-report: run tests in subdirs with -m perf and generate report
# full-report: like test-report: with -m perf and -m slow
test-report perf-report full-report:	${TEST_PROGS}
	@test -z "${TEST_PROGS}" || { \
	  case $@ in \
	  test-report) test_options="-k";; \
	  perf-report) test_options="-k -m=perf";; \
	  full-report) test_options="-k -m=perf -m=slow";; \
	  esac ; \
	  if test -z "$$GTESTER_LOGDIR" ; then	\
	    ${GTESTER} --verbose $$test_options -o test-report.xml ${TEST_PROGS} ; \
	  elif test -n "${TEST_PROGS}" ; then \
	    ${GTESTER} --verbose $$test_options -o `mktemp "$$GTESTER_LOGDIR/log-XXXXXX"` ${TEST_PROGS} ; \
	  fi ; \
	}
	@ ignore_logdir=true ; \
	  if test -z "$$GTESTER_LOGDIR" ; then \
	    GTESTER_LOGDIR=`mktemp -d "\`pwd\`/.testlogs-XXXXXX"`; export GTESTER_LOGDIR ; \
	    ignore_logdir=false ; \
	  fi ; \
	  if test -d "$(top_srcdir)/.git"; then \
	    export REVISION="`git describe`" ;  \
	  else \
	    export REVISION="undefined" ; \
	  fi ; \
	  export TIMESTAMP=`date +%Y-%m-%dT%H:%M:%S%z` ; \
	  for subdir in $(SUBDIRS) . ; do \
	    test "$$subdir" = "." -o "$$subdir" = "po" || \
	    ( cd $$subdir && $(MAKE) $(AM_MAKEFLAGS) $@ ) || exit $? ; \
	  done ; \
	  $$ignore_logdir || { \
	    echo '<?xml version="1.0"?>'                 > $@.xml ; \
	    echo '<report-collection>'                  >> $@.xml ; \
	    echo '<info>'                               >> $@.xml ; \
	    echo '  <package>$(PACKAGE)</package>'      >> $@.xml ; \
	    echo '  <version>$(VERSION)</version>'      >> $@.xml ; \
	    echo "  <revision>$$REVISION</revision>"    >> $@.xml ; \
	    echo "  <date>$$TIMESTAMP</date>"           >> $@.xml ; \
	    echo '</info>'                              >> $@.xml ; \
	    for lf in `ls -L "$$GTESTER_LOGDIR"/.` ; do \
	      sed '1,1s/^<?xml\b[^>?]*?>//' <"$$GTESTER_LOGDIR"/"$$lf" >> $@.xml ; \
	    done ; \
	    echo >> $@.xml ; \
	    echo '</report-collection>' >> $@.xml ; \
	    rm -rf "$$GTESTER_LOGDIR"/ ; \
	    ${GTESTER_REPORT} --version 2>/dev/null 1>&2 ; test "$$?" != 0 || ${GTESTER_REPORT} $@.xml >$@.html ; \
	  }
.PHONY: test test-report perf-report full-report test-nonrecursive

# run tests in cwd as part of make check
check-local: test-nonrecursive
