module: objective-c
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
         define dynamic C-mapped-subtype ?name (?supers)
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

define traced macro objc-class-definer
  { define objc-class ?:name (?super:name) => ?objc-name:name
      ?methods:*
    end }
    => { begin
           let new-class = objc/allocate-class-pair(?super, ?"objc-name");
           objc/register-class-pair(new-class);
         end;
         define objc-shadow-class ?name (?super) => ?objc-name;
         let objc-class = "$" ## ?objc-name;
         ?methods }

  methods:
    { } => { }
    { bind ?selector:name => ?dylan-method:name (?encoding:expression) ?method-clauses; ... } 
      => { objc/add-method(objc-class, ?selector, ?dylan-method ## "-c-wrapper", ?encoding); 
           define c-callable-wrapper ?dylan-method ## "-c-wrapper" of ?dylan-method
             ?method-clauses
           end;
           ... }

  method-clauses:
    { parameter ?:variable, ... } => { parameter ?variable; ... }
    { result ?:variable, ... } => { result ?variable; ... }
    { } => { }
end;

define macro send
  { send(?target:expression, ?selector:name, ?args:*) }
    => { "%send-" ## ?selector (?target, ?args) }
end;
