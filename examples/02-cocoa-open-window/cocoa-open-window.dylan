Module: cocoa-open-window
Synopsis: 
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define constant $window = send(send($NSWindow, @alloc), @init);

// This is our callback for when the application has launched.
define objc-method finished-launching (self, cmd, notification) => ()
  c-signature: (self :: <MyDelegate>, cmd :: <objc/selector>, notification :: <NSNotification>) => ();
  send($window, @make-key-and-order-front, $window);
end;

// Create our delegate class and add a method for our callback
define objc-class <MyDelegate> (<NSObject>) => MyDelegate
  bind @applicationDidFinishLaunching/ => finished-launching;
end;

define function main (name :: <string>, arguments :: <vector>)
  // We don't use NSApplicationMain as we don't have a bundle or a nib or
  // anything normal yet.

  let app = send($NSApplication, @shared-application);

  // Create our delegate and set it on the app
  let delegate = send(send($MyDelegate, @alloc), @init);
  send(app, @set-delegate/, delegate);

  // Now we're good to go ...
  send(app, @run);

end function main;

main(application-name(), application-arguments());
