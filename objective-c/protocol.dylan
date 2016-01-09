module: objective-c
synopsis: Some basics for talking to the Objective C 2 runtime.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define C-subtype <objc/protocol> (<C-statically-typed-pointer>)
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
        (primitive-cast-pointer-as-raw
          (%call-c-function ("objc_getProtocol")
                (name :: <raw-byte-string>)
             => (object :: <raw-c-pointer>)
                (primitive-string-as-raw(name))
           end));
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
            (objc-protocol :: <raw-c-pointer>)
         => (name :: <raw-byte-string>)
          (primitive-unwrap-c-pointer(objc-protocol))
       end)
end;

define sealed method \=
    (prtcl1 :: <objc/protocol>, prtcl2 :: <objc/protocol>)
 => (equal? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("protocol_isEqual")
        (prtcl1 :: <raw-c-pointer>,
         prtcl2 :: <raw-c-pointer>)
     => (equal? :: <raw-boolean>)
      (primitive-unwrap-c-pointer(prtcl1), primitive-unwrap-c-pointer(prtcl2))
    end)
end;

define method objc/conforms-to-protocol?
    (objc-protocol :: <objc/protocol>,
     protocol :: <objc/protocol>)
 => (conforms? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("protocol_conformsToProtocol")
         (objc-protocol :: <raw-c-pointer>,
          protocol :: <raw-c-pointer>)
      => (conforms? :: <raw-boolean>)
       (primitive-unwrap-c-pointer(objc-protocol),
        primitive-unwrap-c-pointer(protocol))
     end)
end;

define method objc/add-protocol
    (objc-protocol :: <objc/protocol>,
     protocol :: <objc/protocol>)
 => (added? :: <boolean>)
  primitive-raw-as-boolean
    (%call-c-function ("protocol_addProtocol")
         (objc-protocol :: <raw-c-pointer>,
          protocol :: <raw-c-pointer>)
      => (added? :: <raw-boolean>)
       (primitive-unwrap-c-pointer(objc-protocol),
        primitive-unwrap-c-pointer(protocol))
     end)
end;
