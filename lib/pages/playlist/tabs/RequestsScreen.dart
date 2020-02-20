import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/Request.dart';
import 'package:cmp/models/playlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RequestScreen extends StatefulWidget {
  final Playlist _playlist;
  RequestScreen(this._playlist);

  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  List<Request> _requests = [];

  void initState() {
    super.initState();

    Controller().firebase.getPlaylistRequests(this.widget._playlist).then((pRequests) {
      setState(() {
        this._requests = pRequests;
      });
    });
  }

  void _deleteRequest(Request pRequest) {
    setState(() {
      this._requests.removeWhere((item) => item.requestID == pRequest.requestID);
    });
  }

  Widget build(BuildContext context) {
    if (this._requests.length == 0) {
      return Center(
        child: Text("Keine Anfragen vorhanden"),
      );
    }
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: this._requests.length,
      itemBuilder: (BuildContext context, int index) {
        return RequestItem(this.widget._playlist, this._requests[index], this._deleteRequest);
      },
    );
  }
}

class RequestItem extends StatelessWidget {
  final Playlist _playlist;
  final Request _request;
  final Function(Request) _deleteRequestCallback;

  RequestItem(this._playlist, this._request, this._deleteRequestCallback);

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        leading: Container(
          height: 50,
          width: 50,
          //margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: (AssetImage('assets/images/playlist.jpg')),
            ),
          ),
        ),
        title: Text(
          this._request.user.username,
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          "Keine Ahnugn was hier stehen soll",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                this._request.accept();
                Controller().firebase.updateRequest(this._playlist, this._request).then((_) {});
                this._deleteRequestCallback(this._request);
              },
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                this._request.decline();
                Controller().firebase.updateRequest(this._playlist, this._request).then((_) {
                  this._deleteRequestCallback(this._request);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
