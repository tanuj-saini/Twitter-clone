import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String Email;
  final String name;
  final String UserID;
  final String USerPhotoUrl;
  final String bannerUrl;
  final List<String> following;
  final List<String> followers;
  final String bio;
  final bool isTwitterBlue;

  UserModel({
    required this.Email,
    required this.name,
    required this.UserID,
    required this.USerPhotoUrl,
    required this.bannerUrl,
    required this.following,
    required this.followers,
    required this.bio,
    required this.isTwitterBlue,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'Email': Email,
      'name': name,
      'UserID': UserID,
      'USerPhotoUrl': USerPhotoUrl,
      'bannerUrl': bannerUrl,
      'following': following,
      'followers': followers,
      'bio': bio,
      'isTwitterBlue': isTwitterBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      Email: map['Email'] ?? '',
      name: map['name'] ?? '',
      UserID: map['UserID'] ?? '',
      USerPhotoUrl: map['USerPhotoUrl'] ?? '',
      bannerUrl: map['bannerUrl'] ?? '',
      following: List<String>.from(map['following']),
      followers: List<String>.from(map['followers']),
      bio: map['bio'] ?? '',
      isTwitterBlue: map['isTwitterBlue'] ?? false,
    );
  }
 

  UserModel copyWith({
    String? Email,
    String? name,
    String? UserID,
    String? USerPhotoUrl,
    String? bannerUrl,
    List<String>? following,
    List<String>? followers,
    String? bio,
    bool? isTwitterBlue,
  }) {
    return UserModel(
      Email: Email ?? this.Email,
      name: name ?? this.name,
      UserID: UserID ?? this.UserID,
      USerPhotoUrl: USerPhotoUrl ?? this.USerPhotoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      bio: bio ?? this.bio,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  
  @override
  String toString() {
    return 'UserModel(Email: $Email, name: $name, UserID: $UserID, USerPhotoUrl: $USerPhotoUrl, bannerUrl: $bannerUrl, following: $following, followers: $followers, bio: $bio, isTwitterBlue: $isTwitterBlue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.Email == Email &&
      other.name == name &&
      other.UserID == UserID &&
      other.USerPhotoUrl == USerPhotoUrl &&
      other.bannerUrl == bannerUrl &&
      listEquals(other.following, following) &&
      listEquals(other.followers, followers) &&
      other.bio == bio &&
      other.isTwitterBlue == isTwitterBlue;
  }

  @override
  int get hashCode {
    return Email.hashCode ^
      name.hashCode ^
      UserID.hashCode ^
      USerPhotoUrl.hashCode ^
      bannerUrl.hashCode ^
      following.hashCode ^
      followers.hashCode ^
      bio.hashCode ^
      isTwitterBlue.hashCode;
  }

 
}
