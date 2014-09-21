changelog:
	@if test -d "$(srcdir)/.git"; \
        then \
                echo Creating ChangeLog && \
                ( cd "$(top_srcdir)" && \
                  $(top_srcdir)/missing --run git log --stat ) > ChangeLog.tmp \
                && mv -f ChangeLog.tmp $(top_distdir)/ChangeLog \
                || ( rm -f ChangeLog.tmp ; \
                     echo Failed to generate ChangeLog >&2 ); \
        else \
                echo A git clone is required to generate a ChangeLog >&2; \
        fi

dist-hook: changelog
