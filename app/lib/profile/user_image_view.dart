import 'package:flutter/material.dart';
import 'package:schulplaner8/models/additionaltypes.dart';
import 'package:schulplaner8/models/user.dart';
import 'package:schulplaner8/profile/avatar_image.dart';

import 'url_image.dart';

class UserImageView extends StatelessWidget {
  final bool thumbnailMode;
  final double size;
  final UserProfile userProfile;

  const UserImageView(
      {this.thumbnailMode = false,
      @required this.userProfile,
      this.size = 48.0});

  @override
  Widget build(BuildContext context) {
    switch (userProfile?.displayMode) {
      case ProfileDisplayMode.pic:
        {
          String url = userProfile.pic;
          if (thumbnailMode && userProfile.picThumb != null) {
            url = userProfile.picThumb;
          }
          return UrlImage(
            size: size,
            url: url,
          );
        }
      case ProfileDisplayMode.avatar:
        {
          return AvatarImage(
            size: size,
            avatarData: userProfile.avatar,
          );
        }
      default:
        {
          return StandardIcon(
            size: size,
          );
        }
    }
  }
}
