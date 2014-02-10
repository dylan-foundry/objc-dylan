**************************
Objective C / Dylan Bridge
**************************

.. current-library:: objective-c
.. current-module:: objective-c

The OBJECTIVE-C module
======================

Macros
------

.. macro:: objc-msgsend

.. macro:: objc-protocol-definer

.. macro:: objc-shadow-class-definer

Classes
-------

.. class:: <objc/class>

   :superclasses: <c-statically-typed-pointer>


.. function:: objc/class-name

   :signature: objc/class-name (objc-class) => (objc-class-name)

   :parameter objc-class: An instance of :class:`<objc/class>`.
   :value objc-class-name: An instance of :drm:`<string>`.

.. function:: objc/class-responds-to-selector?

   :signature: objc/class-responds-to-selector? (objc-class selector) => (well?)

   :parameter objc-class: An instance of :class:`<objc/class>`.
   :parameter selector: An instance of :class:`<objc/selector>`.
   :value well?: An instance of :drm:`<boolean>`.

.. function:: objc/get-class

   :signature: objc/get-class (name) => (objc-class)

   :parameter name: An instance of :drm:`<string>`.
   :value objc-class: An instance of ``false-or(<objc/class>)``.

.. function:: objc/get-class-method

   :signature: objc/get-class-method (objc-class selector) => (method?)

   :parameter objc-class: An instance of :class:`<objc/class>`.
   :parameter selector: An instance of :class:`<objc/selector>`.
   :value method?: An instance of ``false-or(<objc/method>)``.

.. function:: objc/get-instance-method

   :signature: objc/get-instance-method (objc-class selector) => (method?)

   :parameter objc-class: An instance of :class:`<objc/class>`.
   :parameter selector: An instance of :class:`<objc/selector>`.
   :value method?: An instance of ``false-or(<objc/method>)``.

Instances
---------

.. class:: <objc/instance>

   :superclasses: <c-statically-typed-pointer>

.. constant:: $nil

.. class:: <objc/instance-address>

   :superclasses: <c-void*>

.. function:: objc/instance-class

   :signature: objc/instance-class (objc-instance) => (objc-class)

   :parameter objc-instance: An instance of :class:`<objc/instance>`.
   :value objc-class: An instance of :class:`<objc/class>`.

.. function:: objc/instance-class-name

   :signature: objc/instance-class-name (objc-instance) => (objc-class-name)

   :parameter objc-instance: An instance of :class:`<objc/instance>`.
   :value objc-class-name: An instance of :drm:`<string>`.

.. function:: objc/instance-size

   :signature: objc/instance-size (objc-class) => (objc-instance-size)

   :parameter objc-class: An instance of :class:`<objc/class>`.
   :value objc-instance-size: An instance of :drm:`<integer>`.

.. function:: objc/make-instance

   :signature: objc/make-instance (raw-instance) => (objc-instance)

   :parameter raw-instance: An instance of ``<machine-word>``.
   :value objc-instance: An instance of :class:`<objc/instance>`.

Methods
-------

.. class:: <objc/method>

   :superclasses: <c-statically-typed-pointer>


.. function:: objc/method-name

   :signature: objc/method-name (objc-method) => (objc-method-selector)

   :parameter objc-method: An instance of :class:`<objc/method>`.
   :value objc-method-selector: An instance of :class:`<objc/selector>`.

Selectors
---------

.. class:: <objc/selector>

   :superclasses: <c-statically-typed-pointer>


.. function:: objc/register-selector

   :signature: objc/register-selector (name) => (objc-selector)

   :parameter name: An instance of :drm:`<string>`.
   :value objc-selector: An instance of :class:`<objc/selector>`.

.. function:: objc/selector-name

   :signature: objc/selector-name (objc-selector) => (selector-name)

   :parameter objc-selector: An instance of :class:`<objc/selector>`.
   :value selector-name: An instance of :drm:`<string>`.

Associated Objects
------------------

.. generic-function:: objc/associated-object

   :signature: objc/associated-object (objc-instance key) => (objc-instance)

   :parameter objc-instance: An instance of :class:`<objc/instance>`.
   :parameter key: An instance of ``<object>``.
   :value objc-instance: An instance of :class:`<objc/instance>`.

.. function:: objc/remove-associated-objects

   :signature: objc/remove-associated-objects (objc-instance) => ()

   :parameter objc-instance: An instance of :class:`<objc/instance>`.

.. constant:: $objc-association-assign

.. constant:: $objc-association-copy

.. constant:: $objc-association-copy-nonatomic

.. constant:: $objc-association-retain-nonatomic

.. constant:: $objc-association-return

.. generic-function:: objc/set-associated-object

   :signature: objc/set-associated-object (objc-instance key value association-policy) => ()

   :parameter objc-instance: An instance of :class:`<objc/instance>`.
   :parameter key: An instance of ``<object>``.
   :parameter value: An instance of :class:`<objc/instance>`.
   :parameter association-policy: An instance of :drm:`<integer>`.

Core Foundation Bindings
------------------------

.. class:: <<ns/object>>
   :abstract:

   :superclasses: :drm:`<object>`

.. class:: <ns/object>

   :superclasses: :class:`<objc/instance>`, :class:`<<ns/object>>`

