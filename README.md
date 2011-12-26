# cheatorious

_"Being victorious through a means so amazing it cannot possibly be achieved without cheating."_ 
(Urban Dictionary)

[![Build Status](https://secure.travis-ci.org/lfcipriani/cheatorious.png)](http://travis-ci.org/lfcipriani/cheatorious)

**cheatorious** is a generator of simple, searchable, shareable, modular command-line cheatsheets.

Cheatsheets are very good to start learning or keep knowledge of some language or tool, but very often you just don't have the proper cheatsheet at hand when you need to remember that cryptic keyboard shortcut. Furthermore, wouldn't be nice to keep or create your own cheatsheets in a neat ruby DSL? Wouldn't be great if you have easy access to them, such as via command-line interface?

## Install ##

    gem install cheatorious
    
Cheatorious is compatible with ruby 1.8.x, 1.9.x, rubinius, jruby, ree and more.

## Creating your Cheatsheet ##

Create a file and use the following syntax, shown in the example below:

    cheatsheet_for "Simple VIM" do
        # put some info about you, if you want to share this later
        description "A simple VIM cheatsheet for tests"
        author      "Luis Cipriani", "github.com/lfcipriani"
        version     "1.0.0"

        # you can configure some keyboard keys variables
        key :control, "^"
        key :esc    , "<esc>"
        key :leader , ","
        
        # your prefered keyboard keys separators (default is empty string)
        key_separator " "

        # this is an cheatsheet entry, the first parameter is what the entry does, the other are the shortcuts or descriptions
        __ "Enter insertion mode", "i"
        __ "Exit insertion mode" , _esc

        # you can create sections, that will be searchable
        section "Basic Movement" do
            __ "character left, right, line up, line down", "h", "l", "k", "j"
            __ "word/token left, right"                   , "b", "w"
        end

        section "Scrolling" do
            # this is how you use the pre-configured keyboard keys
            __ "scroll line up, down", (_control "E"), (_control "Y")
            __ "scroll page up, down", (_control "F"), (_control "B")
            __ "crazy scroll", (_leader _control "A") # this is just to show you can combine keys \o/
        end

        section "Files" do
            __ "Open file", ":e"

            # you can go infinitely deep with sections
            section "Saving" do
                __ "Save file", ":w"
            end
        end
    end

## Compiling your cheatsheet ##

In this alpha version, the compilation is transparently done by cheatorious, but in future versions you'll be able to:

* serialize your cheatsheet for exporting
* export in Base64 to make the search faster
* export a standalone executable script

## Using cheatorious ##

The CLI usage goes as follows:

    $ cheatorious cheatsheet_file [keyword]
    
Where *cheatsheet_file* is the file you created above using the ruby DSL and a optional *keyword* if you want to filter the cheatsheet (case insensitive). If no keyword is passed, it will return whole cheatsheet.

I'm working to let this usage even more simple and fast.

## TODO ##

* search by sections
* reverse search
* standalone script generation
* case sensitive search
* better ouput layout, colored
* more features in command line
* other output writers

## Tips ##

* In Macs, cheatorious is very powerful if used with [DTerm](http://decimus.net/DTerm)
* Create aliases to save typings

## Contributing ##

You can contribute in the Core, with Writers or Cheatsheets, feel free.

* Fork
* Implement tests
* Implement feature
* Test it
* Pull request

----
_Copyright (c) 2011 Luis Cipriani (under MIT license)_
