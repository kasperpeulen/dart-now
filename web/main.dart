import 'dart:html';
import 'dart:async';

import 'package:github/browser.dart';
import 'package:dartnow/dart_snippet.dart';
import 'package:dartnow/common.dart';

Set<String> gistIds = [
  '8cefaa4f72db16e0f9ee',
  '95e7eb260a737c0828dd',
  'dd353c3d95b2da3dd74b',
  '5a0e89c90c8a732aa744',
  '8b288fc737b7069d04eb',
  '1779cb03472912a1359e',
  'fa2c0825619512750c86',
  '9b71b6f5f094e658043c',
  '5cd660b5088311c64872',
].toSet();

Set<Gist> gists;
Set<DartSnippet> snippets;

DivElement snippetsDivElement = querySelector('#snippets');
InputElement libraryInputElement = querySelector('#library');
InputElement elementInputElement = querySelector('#dart_element');
InputElement keywordsInputElement = querySelector('#keywords');

main() async {
  await fetchGists();

  filterGistsAndShow();

  libraryInputElement.onInput.listen((e) => filterGistsAndShow());
  elementInputElement.onInput.listen((e) => filterGistsAndShow());
  keywordsInputElement.onInput.listen((e) => filterGistsAndShow());
}

fetchGists() async {
  // this authentication is very limited
  // we should make a login system I guess
  Authentication auth = new Authentication.anonymous();
  //  var auth = new Authentication.basic('kasperpeulen', '****');
  GitHub gitHub = createGitHubClient(auth: auth);
  gists = (await Future.wait(
          gistIds.map((String id) async => await gitHub.gists.getGist(id))))
      .toSet();
  snippets = gists.map((Gist gist) => new DartSnippet(gist)).toSet();
}

filterGistsAndShow() {
  // remove old output first
  snippetsDivElement.innerHtml = "";

  List<String> keywords = keywordsInputElement.value.split(' ');
  List<String> elements = elementInputElement.value.split(', ');
  Set<DartSnippet> filtered =
      snippets.where((snippet) =>
        snippet.centralLibrary.contains(libraryInputElement.value) &&
        elements.any((inputElement) =>
           snippet.centralElements.any((element) =>
              element.contains(inputElement))) &&
        keywords.every((s) => snippet.description.contains(s))).toSet();
  filtered.forEach(renderSnippet);
}

renderSnippet(DartSnippet snippet) {
  DivElement output = new DivElement()
    ..setInnerHtml('''
    <b>Main library:</b> ${snippet.centralLibrary}<br>
    <b>Main element${snippet.centralElements.length > 1 ? "s" : ""}:</b>
    ${snippet.centralElements.toString().replaceAll('{','').replaceAll('}','')}<br>
    <b>Description:</b> ${snippet.description}<br>
    <b>Author:</b> ${snippet.gist.owner.login}<br>
    <b>Gist:</b> <a href="${snippet.gist.htmlUrl}">${snippet.gist.htmlUrl}</a><br>
    ${snippet.centralLibrary.contains('dart') ?
    '''
      <b>Dartpad:</b>
      <a href="https://dartpad.dartlang.org/${snippet.gist.id}">
        https://dartpad.dartlang.org/${snippet.gist.id}
      </a><br>
    ''' : ''}
    ''', validator: new TrustedNodeValidator())
    ..classes.addAll(['snippet', 'mdl-shadow--2dp']);

  snippetsDivElement.append(output);
}
