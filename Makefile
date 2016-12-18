.PHONY: install build

default: install

clean:
	rm -f flow

format:
	gofmt -w flow.go

build: clean format
	go build flow.go

install: build
	@echo Installing into /usr/local/bin
	@/bin/cp -f flow /usr/local/bin
	@cd commands; \
	for file in *; do \
		/bin/cp -f $$file /usr/local/bin/.flow-$${file%???}; \
	done
