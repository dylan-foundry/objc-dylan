module: objc-test-suite
synopsis: Test suite for the objc library.

define constant $NSObject = objc/get-class("NSObject");

define test objc-class-test ()
  check-equal("Can get NSObject class",
              objc/class-name(objc/get-class("NSObject")),
              "NSObject");
  check-false("Can't get invalid class",
              objc/get-class("Does Not Exist"));
end test objc-class-test;

define test objc-class-instance-size-test ()
  check-true("Can get NSObject class instance size",
              objc/instance-size(objc/get-class("NSObject")) > 0);
end test objc-class-instance-size-test;

define test objc-selector-test ()
  check-equal("Can register selector",
              objc/selector-name(objc/register-selector("alloc")),
              "alloc");
end test objc-selector-test;

define test objc-selector-equal-test ()
  let sel1 = objc/register-selector("hello");
  let sel2 = objc/register-selector("world");
  let sel3 = objc/register-selector("hello");
  check-true("Same selectors are equal", sel1 = sel1);
  check-true("Same, but created separately, selectors are equal", sel1 = sel3);
  check-false("Different selectors are not equal", sel1 = sel2);
end test objc-selector-equal-test;

define test objc-responds-to-test ()
  let ns-object = objc/get-class("NSObject");
  check-true("NSObject responds to description",
             objc/class-responds-to-selector?(ns-object, objc/register-selector("description")));
  check-false("NSObject doesn't responds to allocFoobar",
              objc/class-responds-to-selector?(ns-object, objc/register-selector("allocFoobar")));
end test objc-responds-to-test;

define test objc-get-class-method-test ()
  let ns-object = objc/get-class("NSObject");
  let description-SEL = objc/register-selector("description");
  let description-method = objc/get-class-method(ns-object, description-SEL);
  check-equal("NSObject has a class method 'description'",
              objc/method-name(description-method), description-SEL);
  let bad-method-SEL = objc/register-selector("allocFoobar");
  check-false("NSObject doesn't have a class method 'allocFoobar'",
              objc/get-class-method(ns-object, bad-method-SEL));
end test objc-get-class-method-test;

define test objc-get-instance-method-test ()
  let ns-object = objc/get-class("NSObject");
  let description-SEL = objc/register-selector("description");
  let description-method = objc/get-instance-method(ns-object, description-SEL);
  check-equal("NSObject has an instance method 'description'",
              objc/method-name(description-method), description-SEL);
  let bad-method-SEL = objc/register-selector("allocFoobar");
  check-false("NSObject doesn't have an instance method 'allocFoobar'",
              objc/get-instance-method(ns-object, bad-method-SEL));
end test objc-get-instance-method-test;

define objc-selector @alloc
  parameter target :: <objc/class>;
  result objc-instance :: <objc/instance>;
  selector: "alloc";
end;

define objc-selector @retain-count
  parameter target :: <objc/instance>;
  result retain-count :: <C-int>;
  selector: "retainCount";
end;

define test objc-alloc-test ()
  let objc-instance = send($NSObject, @alloc);
  check-true("Newly created object is an instance of <NSObject>",
             instance?(objc-instance, <NSObject>));
end test objc-alloc-test;

define test objc-send-test ()
  let objc-instance = send($NSObject, @alloc);
  let rc = send(objc-instance, @retain-count);
  check-equal("Newly created object has a retain count of 1",
              rc, 1);
end test objc-send-test;

define test objc-instance-class-test ()
  let objc-instance = send($NSObject, @alloc);
  let class-name = objc/class-name(objc/instance-class(objc-instance));
  check-equal("Newly created object has the correct class",
              class-name, "NSObject");
end test objc-instance-class-test;

define test objc-instance-class-name-test ()
  let objc-instance = send($NSObject, @alloc);
  check-equal("Newly created object has the correct class name",
              objc/instance-class-name(objc-instance), "NSObject");
end test objc-instance-class-name-test;

define test objc-associated-objects-test ()
  let objc-instance = send($NSObject, @alloc);
  check-equal("Newly created object hasn't got associated object",
              objc/associated-object(objc-instance, "foobar"), $nil);
  objc/set-associated-object(objc-instance, "foobar", objc-instance, $OBJC-ASSOCIATION-ASSIGN);
  check-equal("Adding an associated object works",
              objc/associated-object(objc-instance, "foobar"), objc-instance);
  objc/remove-associated-objects(objc-instance);
  check-equal("Removing associated objects works",
              objc/associated-object(objc-instance, "foobar"), $nil);
end test objc-associated-objects-test;

define test objc-print-object-test ()
  local method print-to-string (obj)
          let stream = make(<byte-string-stream>,
                            direction: #"output",
                            contents: make(<byte-string>,
                                           size: 1000));
          format(stream, "%=", obj);
          stream-contents(stream)
        end;
  assert-equal("{<objc/selector> alloc}",
               print-to-string(@alloc));
  assert-equal("{<objc/class> NSObject}",
               print-to-string($NSObject));
  let <<NSObject>> = objc/get-protocol("NSObject");
  assert-equal("{<objc/protocol> NSObject}",
               print-to-string(<<NSObject>>));
end test objc-print-object-test;

define objc-selector @adder
  parameter target :: <NSObject>;
  parameter a :: <C-int>;
  result r :: <C-int>;
  selector: "adder:";
end;

define objc-method adder
    (target, selector, a :: <integer>)
 => (r :: <integer>)
  c-signature: (target :: <objc/instance>,
                selector :: <objc/selector>,
                a :: <C-int>) => (r :: <C-int>);
  assert-true(instance?(target, <test-class>));
  a + 1
end;

define objc-class <test-class> (<NSObject>) => DylanTestClass
  bind @adder => adder ("i@:i");
end;

define test objc-create-subclass-test ()
  let new-subclass = objc/get-class("DylanTestClass");
  assert-equal($DylanTestClass, new-subclass);
  let objc-instance = send(new-subclass, @alloc);
  check-equal("Newly created subclass has the correct class name",
              objc/instance-class-name(objc-instance), "DylanTestClass");
end test objc-create-subclass-test;

define test objc-add-method-test ()
  let i = send($DylanTestClass, @alloc);
  assert-equal(3, send(i, @adder, 2));
end;

define test objc-super-class-test ()
  assert-false(objc/super-class($NSObject));
  assert-equal(objc/super-class($DylanTestClass), $NSObject);
end;

define test objc-protocol-lookup-test ()
  let <<NSObject>> = objc/get-protocol("NSObject");
  assert-equal("NSObject", objc/protocol-name(<<NSObject>>));
  assert-false(objc/get-protocol("NoSuchProtocolExists"));
end test objc-protocol-lookup-test;

define test objc-protocol-equal-test ()
  assert-equal(objc/get-protocol("NSObject"),
               objc/get-protocol("NSObject"));
  assert-not-equal(objc/get-protocol("NSObject"),
                   objc/get-protocol("NoSuchProtocolExists"));
end test objc-protocol-equal-test;

define test objc-conforms-to-protocol-test ()
  assert-true(objc/conforms-to-protocol?(objc/get-class("NSObject"),
                                         objc/get-protocol("NSObject")));
end test objc-conforms-to-protocol-test;

define suite objc-test-suite ()
  test objc-class-test;
  test objc-class-instance-size-test;
  test objc-selector-test;
  test objc-selector-equal-test;
  test objc-responds-to-test;
  test objc-get-class-method-test;
  test objc-get-instance-method-test;
  test objc-alloc-test;
  test objc-send-test;
  test objc-instance-class-test;
  test objc-instance-class-name-test;
  test objc-associated-objects-test;
  test objc-print-object-test;
  test objc-create-subclass-test;
  test objc-add-method-test;
  test objc-super-class-test;
  test objc-protocol-lookup-test;
  test objc-protocol-equal-test;
  test objc-conforms-to-protocol-test;
end suite;
