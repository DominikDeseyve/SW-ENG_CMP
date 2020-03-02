import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/models/playlist.dart';
import 'package:flutter/material.dart';

class PaginationModule {
  List<Playlist> _playlists = [];
  int _stepSize;
  ScrollController _scrollController;
  bool _isFinished;
  DocumentSnapshot _lastDocument;
  dynamic Function({PaginationModule paginationModule}) _snap;
  Function(List<Playlist>) _callback;

  PaginationModule(Function(List<Playlist>) pCallback) {
    this._callback = pCallback;
    this._stepSize = 3;
    this._isFinished = false;
    this._lastDocument = null;

    print("Pagination Snapshot");

    this._scrollController = new ScrollController();
    this._scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        this.loadMore();
      }
    });
  }

  void loadMore() {
    print("LOAD MORE");
    if (!this._isFinished) {
      this.fetch();
    }
  }

  void finish() {
    this._isFinished = true;
  }

  void fetch() {
    this._snap(paginationModule: this).then((QuerySnapshot pQuery) {
      if (pQuery.documents.length == 0) {
        return;
      } else if (pQuery.documents.length <= this._stepSize) {
        this._isFinished = true;
      }
      this._lastDocument = pQuery.documents.last;
      pQuery.documents.forEach((DocumentSnapshot pSnap) {
        _playlists.add(Playlist.fromFirebase(pSnap));
      });
      this._callback(this._playlists);
    });
  }
  //***************************************************//
  //*********   SETTER
  //***************************************************//

  set lastDocument(DocumentSnapshot pSnap) {
    this._lastDocument = pSnap;
  }

  set snap(dynamic Function({PaginationModule paginationModule}) pSnap) {
    this._snap = pSnap;
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  ScrollController get scrollController {
    return this._scrollController;
  }

  int get stepSize {
    return this._stepSize;
  }

  DocumentSnapshot get lastDocument {
    return this._lastDocument;
  }
}
