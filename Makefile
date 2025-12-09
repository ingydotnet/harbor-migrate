M := .cache/makes
$(shell [ -d $M ] || ( git clone -q https://github.com/makeplus/makes $M))

include $M/init.mk
include $M/yamlscript.mk
include $M/clean.mk
include $M/shell.mk

MAKES-CLEAN := \
  migrate-errors.txt \
  values-new.yaml \

test: values-migrated.yaml values-new.yaml
	diff -u $^
	diff -u migrate*
	@echo PASS

values-new.yaml: values-original.yaml harbor-migrate.ys $(YS)
	ys harbor-migrate.ys $< > $@ 2> migrate-errors.txt
