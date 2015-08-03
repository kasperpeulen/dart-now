library dartnow.pubspec;

import 'package:yaml/yaml.dart';

class PubSpec {
  String name;
  String description;

  PubSpec.fromString(String string) {
    dynamic yaml = loadYaml(string);
    name = yaml['name'];
    description = yaml['description'];
  }
}
