library dartnow.dart_snippet;

class DartSnippet {
  final String name;
  final String description;
  final String mainLibrary;
  final String mainElements;
  final String tags;
  final String id;
  final String author;
  final String dartpad;
  final String gist;

  DartSnippet.fromJSON(this.id, Map json) :
    name = json['name'],
    description = json['description'],
    mainLibrary = json['mainLibrary'],
    mainElements = json['mainElements'],
    tags = json['tags'],
    author = json['author'],
    dartpad = json['dartpad'],
    gist = json['gist'];
}
