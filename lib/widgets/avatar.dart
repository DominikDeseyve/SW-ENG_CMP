import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmp/models/user.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final dynamic _item;
  final double width;
  final Key key;

  UserAvatar(this._item, {this.width = 60.0, this.key});

  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      child: (this._item.imageURL == null
          ? Image(
              width: this.width,
              height: this.width,
              image: AssetImage('assets/images/profilbild.webp'),
            )
          : CachedNetworkImage(
              width: this.width,
              height: this.width,
              imageUrl: this._item.imageURL,
              placeholder: (context, url) => Image(
                width: this.width,
                height: this.width,
                image: AssetImage('assets/images/profilbild.webp'),
              ),
              errorWidget: (context, url, error) => Image(
                width: this.width,
                height: this.width,
                image: AssetImage('assets/images/profilbild.webp'),
              ),
              imageBuilder: (context, imageProvider) => Container(
                width: this.width,
                height: this.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    //colorFilter: ColorFilter.mode(materialDesign.light, BlendMode.colorBurn),
                  ),
                ),
              ),
            )),
    );
  }
}
