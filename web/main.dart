import 'dart:html';
import 'dart:async';

import 'package:firebase/firebase.dart';

import 'package:dartnow/dart_snippet.dart';
import 'package:dartnow/common.dart';

List<DartSnippet> snippets = [];

DivElement snippetsDivElement = querySelector('#snippets');
InputElement libraryInputElement = querySelector('#library');
InputElement elementInputElement = querySelector('#dart_element');
InputElement keywordsInputElement = querySelector('#keywords');

main() async {
  await fetchFirebase();

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

  List<String> keywords = keywordsInputElement.value.split(' ');
  List<String> elements = elementInputElement.value.split(' ');

  // TODO refactor this to method in DartSnippet
  bool dependencies(DartSnippet snippet) {
    if (snippet.dependencies == null) return false;
    return snippet.dependencies.keys.any((s) => s.contains(libraryInputElement.value));
  }

  Set<DartSnippet> filtered =
      snippets.where((snippet) =>
         snippet.matches(libraryInputElement.value, elementInputElement.value, keywordsInputElement.value))
      .toSet();
  List<DartSnippet> ordered = filtered.toList()..sort((DartSnippet a, DartSnippet b) =>
      a.matchesMainLibrary(libraryInputElement.value) ? 1 : -1);
  ordered.reversed.forEach(renderSnippet);
}

renderSnippet(DartSnippet snippet) {
  snippetsDivElement.append(snippet.toHtml());
}
