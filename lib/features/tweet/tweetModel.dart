// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TweetModel {
  final String postId;
  final String username;
  final String photoUrl;
  final String USerPhotoUrl;
  //final List<String> retweet;
  // final List<String> likes;
  // final List<String> comments;
  final String UserId;
  final String type;
  final String tweetTitle;
  final String time;
  const TweetModel({
    required this.postId,
    required this.username,
    required this.photoUrl,
    required this.USerPhotoUrl,
    required this.UserId,
    required this.type,
    required this.tweetTitle,
    required this.time,
  });

  TweetModel copyWith({
    String? postId,
    String? username,
    String? photoUrl,
    String? USerPhotoUrl,
    String? UserId,
    String? type,
    String? tweetTitle,
    String? time,
  }) {
    return TweetModel(
      postId: postId ?? this.postId,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      USerPhotoUrl: USerPhotoUrl ?? this.USerPhotoUrl,
      UserId: UserId ?? this.UserId,
      type: type ?? this.type,
      tweetTitle: tweetTitle ?? this.tweetTitle,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'username': username,
      'photoUrl': photoUrl,
      'USerPhotoUrl': USerPhotoUrl,
      'UserId': UserId,
      'type': type,
      'tweetTitle': tweetTitle,
      'time': time,
    };
  }

  factory TweetModel.fromMap(Map<String, dynamic> map) {
    return TweetModel(
      postId: (map["postId"] ?? '') as String,
      username: (map["username"] ?? '') as String,
      photoUrl: (map["photoUrl"] ?? '') as String,
      USerPhotoUrl: (map["USerPhotoUrl"] ?? '') as String,
      UserId: (map["UserId"] ?? '') as String,
      type: (map["type"] ?? '') as String,
      tweetTitle: (map["tweetTitle"] ?? '') as String,
      time: (map["time"] ?? '') as String,
    );
  }

  @override
  String toString() {
    return 'TweetModel(postId: $postId, username: $username, photoUrl: $photoUrl, USerPhotoUrl: $USerPhotoUrl, UserId: $UserId, type: $type, tweetTitle: $tweetTitle, time: $time)';
  }

  @override
  bool operator ==(covariant TweetModel other) {
    if (identical(this, other)) return true;

    return other.postId == postId &&
        other.username == username &&
        other.photoUrl == photoUrl &&
        other.USerPhotoUrl == USerPhotoUrl &&
        other.UserId == UserId &&
        other.type == type &&
        other.tweetTitle == tweetTitle &&
        other.time == time;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        username.hashCode ^
        photoUrl.hashCode ^
        USerPhotoUrl.hashCode ^
        UserId.hashCode ^
        type.hashCode ^
        tweetTitle.hashCode ^
        time.hashCode;
  }
}
