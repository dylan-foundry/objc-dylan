Module: cocoa-hello-world
Synopsis: 
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

// This is our callback for when the application has launched.
define objc-method finished-launching (self, cmd, notification) => ()
  c-signature: (self :: <MyDelegate>, cmd :: <objc/selector>, notification :: <NSNotification>) => ();
  format-out("Hello, world!\n");
  exit-application(0);
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
