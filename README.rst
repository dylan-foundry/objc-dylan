objc-dylan
==========

This is the start of a bridge between Objective C and Dylan.

Pull requests are welcome:

- add more of the low level API
- find a better and consistent way to expose this at a
  higher level

Please note that I do not want any API that is deprecated, so
nothing from pre-Objective C 2.0, etc.  This code will be Lion
and later for Mac OS X and more recent iOS (4 or 5 and later?).

Things to think about:
- What's a good type-friendly way to expose ``objc_msgSend``?
- Where does BridgeSupport fit in here?
