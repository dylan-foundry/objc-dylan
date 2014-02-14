all: build

.PHONY: build test

LIB_SOURCES = $(wildcard objective-c/*.dylan) \
              objective-c/objective-c.lid

TEST_SOURES = $(wildcard tests/*.dylan) \
              $(wildcard tests/*.lid)

build: $(LIB_SOURCES)
	dylan-compiler -build objective-c

test: $(LIB_SOURCES) $(TEST_SOURCES)
	dylan-compiler -build objc-test-suite-app
	_build/bin/objc-test-suite-app

clean:
	rm -rf _build/
