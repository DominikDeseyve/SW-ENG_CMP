import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistAvatar extends StatelessWidget {
  final dynamic _item;
  final double width;
  final Key key;

  PlaylistAvatar(this._item, {this.width = 60.0, this.key});

  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      child: (this._item.imageURL == null
          ? Image(
              width: this.width,
              height: this.width,
              fit: BoxFit.cover,
              image: AssetImage('assets/images/default-playlist-avatar.jpg'),
            )
          : CachedNetworkImage(
              width: this.width,
              height: this.width,
              imageUrl: this._item.imageURL,
              placeholder: (context, url) => Image(
                width: this.width,
                height: this.width,
                image: AssetImage('assets/images/default-playlist-avatar.jpg'),
              ),
              errorWidget: (context, url, error) => Image(
                width: this.width,
                height: this.width,
                image: AssetImage('assets/images/default-playlist-avatar.jpg'),
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
