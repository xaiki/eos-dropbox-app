bin_SCRIPTS = \
	kalite-app \
	kalite-start \
	$(NULL)

%: %.sh
	cp $< $@
	chmod a+x $@

%: %.py
	cp $< $@
	chmod a+x $@

CLEANFILES = \
	$(bin_SCRIPTS) \
	$(NULL)
