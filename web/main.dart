import 'dart:html';
import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:route_hierarchical/client.dart';

import 'package:dartnow/dart_snippet.dart';
import 'package:dartnow/common.dart';

List<DartSnippet> snippets = [];
Router router;
DivElement snippetsDivElement = querySelector('#snippets');
InputElement libraryInputElement = querySelector('#library');
InputElement elementInputElement = querySelector('#dart_element');
InputElement keywordsInputElement = querySelector('#keywords');

main() async {
  await fetchFirebase();

  router = new Router();
  router.root
    ..addRoute(
        name: 'home', defaultRoute: true, path: '/', enter: searchLibrary)
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
        ..addRoute(
            name: 'keywords',
            path: '/keyword/:keywordId',
            enter: searchKeywords)));
  router.listen();

  document.onKeyDown.listen((e) => routerGo());

  libraryInputElement.onInput.listen((e) => routerGo());
  elementInputElement.onInput.listen((e) => routerGo());
  keywordsInputElement.onInput.listen((e) => routerGo());
}

routerGo() {
  String library = libraryInputElement.value == ''
      ? ''
      : '/library/${libraryInputElement.value}';
  String element = elementInputElement.value == ''
      ? ''
      : '/element/${elementInputElement.value}';
  String keyword = keywordsInputElement.value == ''
      ? ''
      : '/keyword/${keywordsInputElement.value}';

  String url = '$library$element$keyword';
  if (url == '') {
    url = '/';
  }
  router.gotoUrl(url);
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

  Set<DartSnippet> filtered = snippets
      .where((snippet) => snippet.matches(libraryInputElement.value,
          elementInputElement.value, keywordsInputElement.value))
      .toSet();
  List<DartSnippet> ordered = filtered.toList()
    ..sort((DartSnippet a, DartSnippet b) {
      if (a.matchesMainLibrary(libraryInputElement.value) &&
          !b.matchesMainLibrary(libraryInputElement.value)) {
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
  filterGistsAndShow();
}

void searchElement(RouteEnterEvent event) {
  elementInputElement.value = event.parameters['elementId'];
  elementInputElement.parent.classes.add('is-dirty');
  filterGistsAndShow();
}

void searchKeywords(RouteEnterEvent event) {
  keywordsInputElement.value = event.parameters['keywordId'];
  keywordsInputElement.parent.classes.add('is-dirty');
  filterGistsAndShow();
}
