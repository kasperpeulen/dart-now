import 'dart:html';
import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:route_hierarchical/client.dart';

import 'package:dartnow/dart_snippet.dart';
import 'package:dartnow/common.dart';

List<DartSnippet> snippets = [];

DivElement snippetsDivElement = querySelector('#snippets');
InputElement libraryInputElement = querySelector('#library');
InputElement elementInputElement = querySelector('#dart_element');
InputElement keywordsInputElement = querySelector('#keywords');

main() async {
  await fetchFirebase();

  var router = new Router();
  router.root
    ..addRoute(
      name: 'library',
      path: '/library/:libraryId',
      enter: searchLibrary,
      mount: (router) => router
    ..addRoute(
          name: 'element',
          path: '/element/:elementId',
          enter: searchElement,
          mount: (router) => router
    ..addRoute(name: 'keywords', path: '/keyword/:keywordId', enter: searchKeywords)));
  router.listen();

  libraryInputElement.onInput.listen((e) => filterGistsAndShow());
  elementInputElement.onInput.listen((e) => filterGistsAndShow());
  keywordsInputElement.onInput.listen((e) => filterGistsAndShow());
}

fetchFirebase() async {
  Firebase firebase = new Firebase('https://dartnow.firebaseio.com/');

  firebase.child('gists').onValue.listen((e) {
    DataSnapshot snapshot = e.snapshot;
    Map json = snapshot.val();
    snippets = [];
    if (json == null) return;
    json.forEach((String key, Map value) {
      snippets.add(new DartSnippet.fromJSON(key, value));
    });
    filterGistsAndShow();
  });

}

filterGistsAndShow() {
  // remove old output first
  snippetsDivElement.innerHtml = "";

  Set<DartSnippet> filtered =
      snippets.where((snippet) =>
         snippet.matches(libraryInputElement.value, elementInputElement.value, keywordsInputElement.value))
      .toSet();
  List<DartSnippet> ordered = filtered.toList()..sort((DartSnippet a, DartSnippet b) {
    if (a.matchesMainLibrary(libraryInputElement.value) && !b.matchesMainLibrary(libraryInputElement.value)) {
      return 1;
    }
    return a.updatedAt.compareTo(b.updatedAt);
  });

  ordered.reversed.forEach(renderSnippet);
}

renderSnippet(DartSnippet snippet) {
  snippetsDivElement.append(snippet.toHtml());
}

void searchLibrary(RouteEnterEvent event) {
  libraryInputElement.value = event.parameters['libraryId'];
  libraryInputElement.parent.classes.add('is-dirty');
}

void searchElement(RouteEnterEvent event) {
  elementInputElement.value = event.parameters['elementId'];
  elementInputElement.parent.classes.add('is-dirty');
}

void searchKeywords(RouteEnterEvent event) {
  keywordsInputElement.value = event.parameters['keywordId'];
  keywordsInputElement.parent.classes.add('is-dirty');
}