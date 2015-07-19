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
  Firebase firebase = new Firebase('https:/dartnow.firebaseio.com/');

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
  Set<DartSnippet> filtered =
      snippets.where((snippet) =>
        snippet.mainLibrary.contains(libraryInputElement.value) &&
        elements.any((inputElement) =>
           snippet.mainElements.split(' ').any((element) =>
              element.contains(inputElement))) &&
        keywords.every((s) => snippet.description.contains(s))).toSet();
  filtered.forEach(renderSnippet);
}

renderSnippet(DartSnippet snippet) {
  DivElement output = new DivElement()
    ..setInnerHtml('''
    <b>Main library:</b> ${snippet.mainLibrary}<br>
    <b>Main element${snippet.mainElements.split(' ').length > 1 ? "s" : ""}:</b>
    ${snippet.mainElements.toString().replaceAll('{','').replaceAll('}','')}<br>
    <b>Description:</b> ${snippet.description}<br>
    <b>Author:</b> ${snippet.author}<br>
    <b>Gist:</b> <a href="${snippet.gist}">${snippet.gist}</a><br>
    ${snippet.mainLibrary.contains('dart') ?
    '''
      <b>Dartpad:</b>
      <a href="https://dartpad.dartlang.org/${snippet.id}">
        https://dartpad.dartlang.org/${snippet.id}
      </a><br>
    ''' : ''}
    ''', validator: new TrustedNodeValidator())
    ..classes.addAll(['snippet', 'mdl-shadow--2dp']);

  snippetsDivElement.append(output);
}
