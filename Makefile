.PHONY: install

default: install

install:
	@/bin/cp -f flow.sh /usr/local/bin/flow
	@cd commands; \
	for file in *; do \
		/bin/cp -f $$file /usr/local/bin/.flow-$${file%???}; \
	done
