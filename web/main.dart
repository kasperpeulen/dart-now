import 'dart:html';
import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:route_hierarchical/client.dart';

import 'package:dartnow/dart_snippet.dart';
import 'package:dartnow/common.dart';
import 'package:dartnow/user.dart';
import 'dart:js';

List<DartSnippet> snippets = [];
List<DartNowUser> users;
Router router;
DivElement snippetsDivElement = querySelector('#snippets');
InputElement libraryInputElement = querySelector('#library');
InputElement elementInputElement = querySelector('#dart_element');
InputElement keywordsInputElement = querySelector('#keywords');

main() async {
  await fetchFirebase();

  router = new Router(useFragment: true);
  router.root
    ..addRoute(name: 'start', path: '/', enter: (_) => routerGo())
    ..addRoute(name: 'search', path: '/search', enter: searchLibrary);
  router.listen();

  document.onKeyUp.listen((e) => routerGo());

  libraryInputElement.onInput.listen((e) => routerGo());
  elementInputElement.onInput.listen((e) => routerGo());
  keywordsInputElement.onInput.listen((e) => routerGo());
}

routerGo() {
  router.go('search', {},
      queryParameters: {
        'library': libraryInputElement.value,
        'element': elementInputElement.value,
        'keyword': keywordsInputElement.value
      });
}

fetchFirebase() async {
  Firebase firebase = new Firebase('https://dartnow.firebaseio.com/');

  firebase.onValue.listen((e) {
    DataSnapshot snapshot = e.snapshot;
    Map json = snapshot.val();
    if (json == null) return;

    Map gists = json['gists'];
    Map usersJson = json['users'];
    snippets = [];
    users = [];
    usersJson.forEach((String username, Map info) {
      users.add(new DartNowUser.fromJSON(info));
    });
    gists.forEach((String key, Map value) {
      snippets.add(new DartSnippet.fromJSON(key, value, users));
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
//  querySelectorAll('button').forEach((button) {
//    context['componentHandler'].callMethod('upgradeElement', [button]);
//  });
}

renderSnippet(DartSnippet snippet){
  snippetsDivElement.append(snippet.toHtml());
}

void searchLibrary(RouteEnterEvent event) {
  String library = event.queryParameters['library'];
  String element = event.queryParameters['element'];
  String keyword = event.queryParameters['keyword'];

  libraryInputElement.value = library;
  elementInputElement.value = element;
  keywordsInputElement.value = keyword;

  if (library.isNotEmpty) {
    libraryInputElement.parent.classes.add('is-dirty');
  } else {
    libraryInputElement.parent.classes.remove('is-dirty');
  }

  if (element.isNotEmpty) {
    elementInputElement.parent.classes.add('is-dirty');
  } else {
    elementInputElement.parent.classes.remove('is-dirty');
  }

  if (keyword.isNotEmpty) {
    keywordsInputElement.parent.classes.add('is-dirty');
  } else {
    keywordsInputElement.parent.classes.remove('is-dirty');
  }

  filterGistsAndShow();
}
