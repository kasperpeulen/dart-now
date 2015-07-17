library dartnow.dart_snippet;

import 'package:github/browser.dart';
import 'package:dartnow/pub_spec.dart';

class DartSnippet {
  Gist gist;
  String name;
  String description = "";
  PubSpec pubspec;

  String centralLibrary;
  Set<String> centralElements;

  DartSnippet(this.gist) {
    name = gist.description;
    var pubspecFile =
        gist.files.firstWhere((file) => file.name == 'pubspec.yaml');
    pubspec = new PubSpec.fromString(pubspecFile.content);
    name = pubspec.name;
    if (pubspec.description != null) description = pubspec.description;
    if (pubspec.name.contains('_')) {
      centralLibrary = pubspec.name.substring(0, pubspec.name.indexOf('_'));
      centralElements = pubspec.name
          .substring(pubspec.name.indexOf('_') + 1)
          .split('_')
          .toSet();
    } else {
      centralLibrary = pubspec.name;
    }
  }
}
