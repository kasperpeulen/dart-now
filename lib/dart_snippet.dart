library dartnow.dart_snippet;

import 'dart:html';
import 'package:dartnow/common.dart';
import 'package:github/browser.dart';
import 'dart:async';

class DartSnippet {
  final String name;
  final String description;
  final String mainLibrary;
  final String mainElements;
  final String tags;
  final String id;
  final String author;
  final String dartpadUrl;
  final Map<String, String> dependencies;
  final String gistUrl;
  final List<String> libraries;
  final DateTime createdAt;
  final DateTime updatedAt;
  User user;

  DartSnippet.fromJSON(this.id, Map json) :
    name = json['name'],
    description = json['description'],
    mainLibrary = json['mainLibrary'],
    mainElements = json['mainElements'],
    dependencies = json['dependencies'],
    createdAt = json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt = json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    tags = json['tags'],
    author = json['author'],
    dartpadUrl = json['dartpadUrl'],
    gistUrl = json['gistUrl'],
    libraries = json['libraries'] ==  null ? [] : json['libraries'] {
    libraries..remove(mainLibrary)..add(mainLibrary)
      ..sort((String a, String b) {
      if(mainLibrary.contains(a)) {
        return -1;
      } else if (a.contains('dart')) {
        return 1;
      }
      return 1;
    });
  }

  DivElement toHtml() {
//    user = await getUser();
    return new DivElement()
      ..setInnerHtml('''
    ${description}<br><br>
    <b>Libraries:</b> <code>${libraries.join(' ').replaceAll(mainLibrary,
    '<em>$mainLibrary</em>')}</code><br>
    <b>Main element${mainElements.split(' ').length > 1 ? "s" : ""}:</b>
    <code>${mainElements}</code><br>
    <b>Author:</b> ${author}<br>
    <!-- <img height="15px" src=user.avatarUrl></img> -->
    <b>Gist:</b> <a href="${gistUrl}" target="_blank">${gistUrl}</a><br>
    ${mainLibrary.contains('dart') ?
    '''
      <b>Dartpad:</b>
      <a href="https://dartpad.dartlang.org/${id}" target="_blank">
        https://dartpad.dartlang.org/${id}
      </a><br>
    ''' : ''}
    ${(true || createdAt == null)  ? '' : '<b>Created </b> ${formatDate(createdAt)}<br>'}
    ${updatedAt == null ? '' : '<b>Updated </b> ${formatDate(updatedAt)}<br>'}

    ${tags.length == 0 ? "" :
    '<b>Tags:</b> ${tags.trim().split(' ').map((t) => '#$t').join(' ')}<br>'}

    ''', validator: new TrustedNodeValidator())
      ..classes.addAll(['snippet', 'mdl-shadow--2dp']);
  }

  bool matches(String libraryInput, String elementInput, String keywordInput) {
    List<String> libraries = []..addAll(this.libraries)..add(mainLibrary);
    List<String> searchLibraries = libraryInput.split(' ');
    List<String> searchElements = elementInput.split(' ');
    List<String> searchKeywords = keywordInput.split(' ');

    if(! searchLibraries.every((search) => _stringIsContainedInList(search, libraries))) {
      return false;
    }
    if(! searchElements.every((search) => _stringIsContainedInList(search, mainElements.split(' ')))) {
      return false;
    }

    if (! searchKeywords.every((search) => _stringIsContainedInList(search,
       description.split(' ')..addAll(tags.split(' ').map((t) => '#$t')))) ) {
      return false;
    }
    return true;
  }

  bool matchesMainLibrary(String libraryInput) {
    List<String> searchLibraries = libraryInput.split(' ');
    if (searchLibraries.length != 1 ) {
      return false;
    }
    return mainLibrary.contains(libraryInput);
  }

  bool _stringIsContainedInList(String string, List<String> list) =>
    list.any((element) => element.contains(string));

//
//  Future<User> getUser() async {
//    GitHub gitHub = createGitHubClient();
//    return await gitHub.users.getUser('kasperpeulen');
//  }
}
