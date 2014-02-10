all: build

.PHONY: build test

LIB_SOURCES = $(wildcard *.dylan) \
              objective-c.lid

TEST_SOURES = $(wildcard tests/*.dylan) \
              $(wildcard tests/*.lid)

build: $(LIB_SOURCES)
	dylan-compiler -build objective-c

test: $(LIB_SOURCES) $(TEST_SOURCES)
	dylan-compiler -build objc-test-suite-app
	_build/bin/objc-test-suite-app

clean:
	rm -rf _build/bin/objc*
	rm -rf _build/lib/*objective*
	rm -rf _build/lib/*objc*
	rm -rf _build/build/objective*
	rm -rf _build/build/objc*
