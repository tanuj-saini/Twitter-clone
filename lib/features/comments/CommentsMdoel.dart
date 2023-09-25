import 'dart:convert';

class CommetsModel {
  final String PostId;
  final String CommentsId;
  final String Comment;
  final String USerProfile;
  final String usserId;
  final DateTime createdAt;
  final String SendToUserName;
  CommetsModel({
    required this.PostId,
    required this.CommentsId,
    required this.Comment,
    required this.USerProfile,
    required this.usserId,
    required this.createdAt,
    required this.SendToUserName,
  });
  



  CommetsModel copyWith({
    String? PostId,
    String? CommentsId,
    String? Comment,
    String? USerProfile,
    String? usserId,
    DateTime? createdAt,
    String? SendToUserName,
  }) {
    return CommetsModel(
      PostId: PostId ?? this.PostId,
      CommentsId: CommentsId ?? this.CommentsId,
      Comment: Comment ?? this.Comment,
      USerProfile: USerProfile ?? this.USerProfile,
      usserId: usserId ?? this.usserId,
      createdAt: createdAt ?? this.createdAt,
      SendToUserName: SendToUserName ?? this.SendToUserName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PostId': PostId,
      'CommentsId': CommentsId,
      'Comment': Comment,
      'USerProfile': USerProfile,
      'usserId': usserId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'SendToUserName': SendToUserName,
    };
  }

  factory CommetsModel.fromMap(Map<String, dynamic> map) {
    return CommetsModel(
      PostId: map['PostId'] ?? '',
      CommentsId: map['CommentsId'] ?? '',
      Comment: map['Comment'] ?? '',
      USerProfile: map['USerProfile'] ?? '',
      usserId: map['usserId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      SendToUserName: map['SendToUserName'] ?? '',
    );
  }

  
  @override
  String toString() {
    return 'CommetsModel(PostId: $PostId, CommentsId: $CommentsId, Comment: $Comment, USerProfile: $USerProfile, usserId: $usserId, createdAt: $createdAt, SendToUserName: $SendToUserName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CommetsModel &&
      other.PostId == PostId &&
      other.CommentsId == CommentsId &&
      other.Comment == Comment &&
      other.USerProfile == USerProfile &&
      other.usserId == usserId &&
      other.createdAt == createdAt &&
      other.SendToUserName == SendToUserName;
  }

  @override
  int get hashCode {
    return PostId.hashCode ^
      CommentsId.hashCode ^
      Comment.hashCode ^
      USerProfile.hashCode ^
      usserId.hashCode ^
      createdAt.hashCode ^
      SendToUserName.hashCode;
  }

 


  
}
