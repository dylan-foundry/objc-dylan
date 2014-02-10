module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define objc-protocol <<ns/object>>;
define objc-shadow-class <ns/object> (<objc/instance>, <<ns/object>>) => NSObject;

define constant $nil = make(<ns/object>,
                            instance: as(<machine-word>, 0));
