import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/Request.dart';
import 'package:cmp/models/playlist.dart';
import 'package:cmp/widgets/UserAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RequestScreen extends StatefulWidget {
  final Playlist _playlist;
  RequestScreen(this._playlist);

  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> with AutomaticKeepAliveClientMixin {
  List<Request> _requests = [];

  void initState() {
    super.initState();

    this._fetchRequests();
  }

  Future<void> _fetchRequests() async {
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
    super.build(context);

    return RefreshIndicator(
      onRefresh: this._fetchRequests,
      color: Colors.redAccent,
      child: (this._requests.length == 0
          ? ListView(
              padding: const EdgeInsets.only(top: 50),
              children: [
                Text(
                  "Keine Anfragen vorhanden",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Controller().theming.fontPrimary,
                  ),
                ),
              ],
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: this._requests.length,
              itemBuilder: (BuildContext context, int index) {
                return RequestItem(this.widget._playlist, this._requests[index], this._deleteRequest);
              },
            )),
    );
  }

  bool get wantKeepAlive => true;
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
        leading: UserAvatar(this._request.user),
        title: Text(
          this._request.user.username,
          style: TextStyle(
            fontSize: 18,
            color: Controller().theming.fontPrimary,
          ),
        ),
        subtitle: Text(
          this._request.createdAtString,
          style: TextStyle(
            color: Controller().theming.fontTertiary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: Controller().theming.fontPrimary,
              ),
              onPressed: () {
                this._request.accept();
                Controller().firebase.updateRequest(this._playlist, this._request).then((_) {});
                this._deleteRequestCallback(this._request);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Controller().theming.fontPrimary,
              ),
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
