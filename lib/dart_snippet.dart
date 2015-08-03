library dartnow.dart_snippet;

import 'dart:html';
import 'package:dartnow/common.dart';
import 'package:github/browser.dart';
import 'dart:async';
import 'package:dartnow/user.dart';
import 'dart:js';
import 'package:firebase/firebase.dart';
import 'info_dialog.dart';

class DartSnippet {
  final String name;
  final String description;
  final String shortDescription;
  final String mainLibrary;
  String mainElements;
  final String tags;
  final String id;
  final String author;
  final String dartpadUrl;
  final Map<String, String> dependencies;
  final String gistUrl;
  final List<String> libraries;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CurrentUser currentUser;
  InfoDialog infoDialog;

  List<DartNowUser> users;
  DartNowUser user;

  DartSnippet.fromJSON(this.id, Map json, this.users, this.currentUser)
      : name = json['name'],
        description = json['description'],
        shortDescription = json['shortDescription'],
        mainLibrary = json['mainLibrary'],
        mainElements = json['mainElements'],
        dependencies = json['dependencies'],
        createdAt = json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt = json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        tags = json['tags'],
        author = json['author'],
        dartpadUrl = json['dartpadUrl'],
        gistUrl = json['gistUrl'],
        libraries = json['libraries'] == null ? [] : json['libraries'] {
    libraries
      ..removeWhere((l) => mainLibrary.contains(l))
      ..addAll(mainLibrary.split(' '))
      ..sort((String a, String b) {
        if (mainLibrary.contains(a)) {
          return -1;
        } else if (a.contains('dart')) {
          return 1;
        }
        return 1;
      });
    infoDialog = new InfoDialog();
    user = users.firstWhere((DartNowUser user) => user.username == author);
  }

  DivElement toHtml() {
    List<String> temp = new List.from(libraries);

    temp..removeWhere((l) => mainLibrary.contains(l));
    String libString =
        temp.isEmpty ? '' : '<code>${temp.join('</code> <code>')}</code>';
    mainElements =
        '<code>${mainElements.split(' ').join('</code> <code>')}</code>';
    DivElement div = new DivElement()
      ..setInnerHtml('''
<div class="flex">
  ${shortDescription}
  <b>Libraries:</b> <code><em>$mainLibrary</em></code> ${libString}<br>
  <b>Main element${mainElements.split(' ').length > 1 ? "s" : ""}:</b>${mainElements}<br>
  <b>Gist:</b> <a href="${gistUrl}" onclick="trackOutboundLink('${gistUrl}'); return false;" target="_blank">${gistUrl}</a><br>
  ${libraries.every((l) => l.contains('dart:')) ?
  '''
  <b>Dartpad:</b>
  <a href="https://dartpad.dartlang.org/${id}" onclick="trackOutboundLink('https://dartpad.dartlang.org/${id}'); return false;" target="_blank">
    https://dartpad.dartlang.org/${id}
  </a><br>
''' : ''}
  ${tags.length == 0 ? "" : '<b>Tags:</b> ${tags.trim().split(' ').map((t) => '#$t').join(' ')}<br>'}
</div>
<div class="vertical layout" style="margin-left:20px; width: 170px">
  <div class="insert-button flex self-center horizontal layout">
  </div>
  <div>
    <div>updated ${formatDate(updatedAt)}</div>
    <div style="margin-top: 5px">
      <img height="40px" style="float:left; margin: 0 5px 0 0" src="${user.avatarUrl}">
      by ${user.username}<br>
      ${user.gistCount} point${user.gistCount > 1 ? 's' : ''}
    </div>
  </div>
</div>''', validator: new TrustedNodeValidator())
      ..classes.addAll(['snippet', 'mdl-shadow--2dp', 'horizontal', 'layout']);
    ButtonElement button = new ButtonElement()
      ..classes.addAll(['flex', 'self-center'])
      ..text = "GET"
      ..id = "$id"
      ..classes.addAll(
          'self-center mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect'
              .split(' '));

    button.onClick.listen((e) {
      Firebase firebase = new Firebase('https://dartnow.firebaseio.com/');
      if (currentUser != null) {
        firebase.child('get').child(currentUser.login).set(id);
      }
      infoDialog.show();
    });
    div.querySelector('.insert-button').children.insert(0, button);

    return div;
  }

  bool matches(String libraryInput, String elementInput, String keywordInput) {
    List<String> libraries = []
      ..addAll(this.libraries)
      ..add(mainLibrary);
    List<String> searchLibraries = libraryInput.split(' ');
    List<String> searchElements = elementInput.split(' ');
    List<String> searchKeywords = keywordInput.split(' ');

    if (!searchLibraries
        .every((search) => _stringIsContainedInList(search, libraries))) {
      return false;
    }
    if (!searchElements.every((search) =>
        _stringIsContainedInList(search, mainElements.split(' ')))) {
      return false;
    }

    if (!searchKeywords.every((search) => _stringIsContainedInList(search,
        description.split(' ')..addAll(tags.split(' ').map((t) => '#$t'))))) {
      return false;
    }
    return true;
  }

  bool matchesMainLibrary(String libraryInput) {
    List<String> searchLibraries = libraryInput.split(' ');
    if (searchLibraries.length != 1) {
      return false;
    }
    return mainLibrary.contains(libraryInput);
  }

  bool _stringIsContainedInList(String string, List<String> list) =>
      list.any((element) => element.contains(string));
}
