library dartnow.dart_snippet;

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

  DartSnippet.fromJSON(this.id, Map json) :
    name = json['name'],
    description = json['description'],
    mainLibrary = json['mainLibrary'],
    mainElements = json['mainElements'],
    dependencies = json['dependencies'],
    tags = json['tags'],
    author = json['author'],
    dartpadUrl = json['dartpadUrl'],
    gistUrl = json['gistUrl'];
}
