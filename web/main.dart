import 'dart:html';
import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:route_hierarchical/client.dart';

import 'package:dartnow/dart_snippet.dart';
import 'package:dartnow/common.dart';
import 'package:dartnow/user.dart';
import 'dart:js';
import 'package:github/browser.dart';
import 'package:mdl/mdl.dart';

List<DartSnippet> snippets = [];
List<DartNowUser> users;
Router router;
DivElement snippetsDivElement = querySelector('#snippets');
InputElement libraryInputElement = querySelector('#library');
InputElement elementInputElement = querySelector('#dart_element');
InputElement keywordsInputElement = querySelector('#keywords');
Firebase firebase;
DivElement loginDiv = querySelector('#login');
CurrentUser user;

main() async {
  firebase = new Firebase('https://dartnow.firebaseio.com/');
//  loginWithGitHub();
  initGithubLogin();
  await fetchFirebase();
  router = new Router(useFragment: true);
  router.root
    ..addRoute(name:'home', path: '/', enter: (_) => routerGo())
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

  firebase.onValue.listen((e) {
    DataSnapshot snapshot = e.snapshot;
    Map json = snapshot.val();
    if (json == null) return;

    Map gists = json['gists'];
    Map usersJson = json['users'];
    snippets = [];
    users = [];
    usersJson.forEach((String username, Map info) {
      if(info != null && info['github_info'] != null) {
        users.add(new DartNowUser.fromJSON(info['github_info']));
      }
    });
    gists.forEach((String key, Map value) {
      snippets.add(new DartSnippet.fromJSON(key, value, users, user));
    });

    filterGistsAndShow();
  });

}

filterGistsAndShow() async {
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
  registerMdl();
  new Future.delayed(new Duration(milliseconds: 600), () async {
    await componentFactory().run();
  });
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


void initGithubLogin() {
  firebase.onAuth().listen((authJson) async {
    if (authJson == null) {
      loginDiv.children = [];
      loginDiv.append(loginButton);
      registerMdl();
      new Future.delayed(new Duration(milliseconds: 600), () async {
        await componentFactory().run();
      });
    } else {

      String accessToken = authJson['github']['accessToken'];
      Authentication auth = new Authentication.withToken(accessToken);
      GitHub gitHub = createGitHubClient(auth: auth);

      user = await gitHub.users.getCurrentUser();
      loginDiv.children = [];
      loginDiv.append(loginInfoButton());
      loginDiv.append(loginMenu());
      await fetchFirebase();
      await filterGistsAndShow();

    }

  });

}

ButtonElement get loginButton {
  final ButtonElement btn = new ButtonElement()
    ..className = "mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect"
    ..text = "Login with github"
    ..onClick.listen((_) {
      firebase.authWithOAuthRedirect('github');
    });
  return btn;
}

ButtonElement loginInfoButton() {
  final ButtonElement btn = new ButtonElement()
    ..setInnerHtml('''
<svg style="width:30px;height:30px" viewBox="0 0 24 24">
  <path fill="#000000" d="M12,2A10,10 0 0,0 2,12C2,16.42 4.87,20.17 8.84,21.5C9.34,21.58 9.5,21.27 9.5,21C9.5,20.77 9.5,20.14 9.5,19.31C6.73,19.91 6.14,17.97 6.14,17.97C5.68,16.81 5.03,16.5 5.03,16.5C4.12,15.88 5.1,15.9 5.1,15.9C6.1,15.97 6.63,16.93 6.63,16.93C7.5,18.45 8.97,18 9.54,17.76C9.63,17.11 9.89,16.67 10.17,16.42C7.95,16.17 5.62,15.31 5.62,11.5C5.62,10.39 6,9.5 6.65,8.79C6.55,8.54 6.2,7.5 6.75,6.15C6.75,6.15 7.59,5.88 9.5,7.17C10.29,6.95 11.15,6.84 12,6.84C12.85,6.84 13.71,6.95 14.5,7.17C16.41,5.88 17.25,6.15 17.25,6.15C17.8,7.5 17.45,8.54 17.35,8.79C18,9.5 18.38,10.39 18.38,11.5C18.38,15.32 16.04,16.16 13.81,16.41C14.17,16.72 14.5,17.33 14.5,18.26C14.5,19.6 14.5,20.68 14.5,21C14.5,21.27 14.66,21.59 15.17,21.5C19.14,20.16 22,16.42 22,12A10,10 0 0,0 12,2Z" />
</svg>
    ''', treeSanitizer: new TrustedSanitizer())
    ..id = "dynamic"
    ..style.zIndex = '100000'
    ..className = "mdl-button mdl-js-button mdl-button--fab mdl-button--mini-fab";
  return btn;
}

DivElement loginMenu() {
  final DivElement menu = new DivElement()
    ..className = 'horizontal layout mdl-menu mdl-menu--bottom-right mdl-js-menu'
    ..style.width = '20px'
    ..attributes.addAll({'for': 'dynamic'})
    ..append(logOutButton());
  return menu;
}

ButtonElement logOutButton() {
  final ButtonElement btn = new ButtonElement()
    ..setInnerHtml('Sign out')
    ..id = "dynamic"
    ..style.margin = "0 5px"
    ..className = "flex self-center mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect"
    ..onClick.listen((_) => firebase.unauth());
  return btn;
}

/**
 * A sanitizer for trees that we trust. It does no validation and allows
 * any elements.
 */
class TrustedSanitizer implements NodeTreeSanitizer {
  const TrustedSanitizer();

  sanitizeTree(Node node) {}
}
