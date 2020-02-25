import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SongAvatar extends StatelessWidget {
  final dynamic _item;
  final double width;
  final Key key;

  SongAvatar(this._item, {this.width = 60.0, this.key});

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
              image: AssetImage('assets/images/default-song-avatar.png'),
            )
          : CachedNetworkImage(
              width: this.width,
              height: this.width,
              imageUrl: this._item.imageURL,
              placeholder: (context, url) => Image(
                width: this.width,
                height: this.width,
                image: AssetImage('assets/images/default-song-avatar.png'),
              ),
              errorWidget: (context, url, error) => Image(
                width: this.width,
                height: this.width,
                image: AssetImage('assets/images/default-song-avatar.png'),
              ),
              imageBuilder: (context, imageProvider) => Container(
                width: this.width,
                height: this.width,
                child: Icon(
                  Icons.music_note,
                  size: 30,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black38, BlendMode.colorBurn),
                  ),
                ),
              ),
            )),
    );
  }
}
