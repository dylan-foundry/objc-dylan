module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define objc-protocol <<NSObject>>;
define objc-shadow-class <NSObject> (<objc/instance>, <<NSObject>>) => NSObject;

define constant $nil = make(<NSObject>,
                            instance: as(<machine-word>, 0));
