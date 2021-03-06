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

define macro objc-class-definer
  { define objc-class ?:name (?super:name) => ?objc-name:name
      ?add-methods:*
    end }
    => {
         begin
           let new-class = objc/allocate-class-pair(?super, ?"objc-name");
           objc/register-class-pair(new-class);
         end;
         define objc-shadow-class ?name (?super) => ?objc-name;
         let objc-class = "$" ## ?objc-name;
         ?add-methods
  }

  add-methods:
    { } => { }
    { ?add-method:*; ... } => { ?add-method; ... }

  add-method:
    { bind ?selector:name => ?dylan-method:name }
      => {
      objc/add-method(objc-class, ?selector,
                      ?dylan-method ## "-c-wrapper",
                      selector-type-encoding(?selector))
    }
end;

define macro objc-method-definer
  { define objc-method ?:name (?args:*) => (?result:variable)
      c-signature: (?cffi-parameters:*) => (?cffi-result:variable);
      ?:body
    end }
    => {
         define function ?name (?args) => (?result)
           ?body
         end;
         define c-callable-wrapper ?name ## "-c-wrapper" of ?name
           ?cffi-parameters ;
           result ?cffi-result
         end;
  }

  { define objc-method ?:name (?args:*) => ()
      c-signature: (?cffi-parameters:*) => ();
      ?:body
    end }
    => {
         define function ?name (?args) => ()
           ?body
         end;
         define c-callable-wrapper ?name ## "-c-wrapper" of ?name
           ?cffi-parameters
         end;
  }

  args:
    { } => { }
    { ?arg:variable, ... } => { ?arg, ... }

  cffi-parameters:
    { } => { }
    { ?cffi-parameter:variable, ... } => { parameter ?cffi-parameter; ... }
end;

define macro send
  { send(?target:expression, ?selector:name, ?args:*) }
    => { "%send-" ## ?selector (?target, ?args) }
end;
