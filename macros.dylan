module: objc
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define macro objc-protocol-definer
  { define objc-protocol ?:name }
    => { define abstract class ?name (<object>)
         end;
  }
end;

define macro objc-shadow-class-definer
  { define objc-shadow-class ?:name (?supers) => ?objc-name:name }
    => { define constant "$" ## ?objc-name = objc/get-class(?"objc-name");
         define class ?name (?supers)
           inherited slot instance-objc-class, init-value: "$" ## ?objc-name;
         end;
         objc/register-shadow-class("$" ## ?objc-name, ?name);
         define method as (class == ?name, objc-instance)
          => (objc-instance :: ?name)
           objc-instance
         end;
  }

  supers:
    { } => { }
    { ?:expression, ... } => { ?expression, ... }
end;

define objc-protocol <<ns/object>>;
define objc-shadow-class <ns/object> (<objc/instance>, <<ns/object>>) => NSObject;
