library dartnow.user;

import 'dart:html';
import 'package:dartnow/common.dart';
import 'package:github/browser.dart';
import 'dart:async';

class DartNowUser {

  final String name;
  final String username;
  final String avatarUrl;
  final List<String> gists;
  final int gistCount;
  final int id;

  DartNowUser.fromJSON(Map json) :
  name = json['name'],
  avatarUrl = json['avatarUrl'],
  username = json['username'],
  gists = json['gists'],
  gistCount = json['gistCount'],
  id = json['id'];
}



