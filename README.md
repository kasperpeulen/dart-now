# Dart Now!

Dart Now is a community driven dart cookbook.

This project is a couple of days old, so idea of the project will probably change a lot.

## What is dartnow ?

Basicly, dartnow is a collection of dart snippets. Users should be able to add snippets to dartnow as public gists.  All kind of code is allowed, the only minimal requirement will be that
the code should run out of the box when the users downloads/clones the gist locally.

A console application snippet should contain a pubspec.yaml file and a main.dart
file. A web application snippet should contain a pubspec.yaml file, a index.html file,
and optionally a main.dart and style.css file.

## Kind of snippets

There a whole lot of different snippets one could come up with. I'm not totally sure of allowing multi dart snippets. This may not be optimal as we use a gist which has a flat structure. In general, I think that short and specific code will fit dartnow the best.

### Extending dartdocs with examples

One kind of snippet that I would like to see at dartnow is, snippets that basicly
extend the dartdocs of some library. For example, say you new to dart, and are reading the
docs of `Element.setInnerHtml`, and you want to see some example.

I want the user to be able to go to dartnow.org, search for `setInnerHtml` and
then find a whole lot of dart snippets where this method is used. The top snippets are the snippets that are starred the most.

There should also be some filtering by relevance. The only purpose the snippet is to show an example of some specific dart element, then this snippet should be lister higher, then some more general code, which lots of different dart elements.

Example: https://gist.github.com/kasperpeulen/95e7eb260a737c0828dd

### Getting started with a library

If you have written a library, and you want users to be able to get quickly started with it, then you could add those examples also to dartnow, for example:

https://gist.github.com/kasperpeulen/9b71b6f5f094e658043c
