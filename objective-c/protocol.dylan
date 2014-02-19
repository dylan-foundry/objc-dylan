module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define C-subtype <objc/protocol> (<C-statically-typed-pointer>)
end;

define inline function as-raw-protocol (objc-protocol :: <objc/protocol>)
  primitive-unwrap-c-pointer(objc-protocol)
end;

define sideways method print-object
    (s :: <objc/protocol>, stream :: <stream>)
 => ()
  format(stream, "{<objc/protocol> %s}", objc/protocol-name(s));
end;

define function objc/get-protocol (name :: <string>)
 => (objc-protocol? :: false-or(<objc/protocol>))
  let raw-objc-protocol
    = primitive-wrap-machine-word
        (%call-c-function ("objc_getProtocol")
              (name :: <raw-byte-string>)
           => (object :: <raw-machine-word>)
            (primitive-string-as-raw(name))
         end);
  if (raw-objc-protocol ~= 0)
    make(<objc/protocol>, address: raw-objc-protocol)
  else
    #f
  end if
end;

define function objc/protocol-name (objc-protocol :: <objc/protocol>)
 => (protocol-name :: <string>)
  primitive-raw-as-string
      (%call-c-function ("protocol_getName")
            (objc-class :: <raw-machine-word>)
         => (name :: <raw-byte-string>)
          (objc-protocol.as-raw-protocol)
       end)
end;

define sealed method \=
    (sel1 :: <objc/protocol>, sel2 :: <objc/protocol>)
 => (equal? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("protocol_isEqual")
        (sel1 :: <raw-machine-word>,
         sel2 :: <raw-machine-word>)
     => (equal? :: <raw-boolean>)
      (sel1.as-raw-protocol, sel2.as-raw-protocol)
    end)
end;

define method objc/conforms-to-protocol?
    (objc-protocol :: <objc/protocol>,
     protocol :: <objc/protocol>)
 => (conforms? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("protocol_conformsToProtocol")
         (objc-protocol :: <raw-machine-word>,
          protocol :: <raw-machine-word>)
      => (conforms? :: <raw-boolean>)
       (objc-protocol.as-raw-protocol,
        protocol.as-raw-protocol)
     end)
end;
