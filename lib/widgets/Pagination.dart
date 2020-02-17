import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaginationStream {
  int _stepSize;
  ScrollController _scrollController;
  Function(QuerySnapshot) _callback;
  bool _isFinished;
  DocumentSnapshot _lastDocument;
  Stream<QuerySnapshot> _stream;
  StreamSubscription<QuerySnapshot> _streamSubscription;

  PaginationStream() {
    this._stepSize = 3;
    this._isFinished = false;
    this._lastDocument = null;

    this._scrollController = new ScrollController();
    this._scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        this.loadMore();
      }
    });
  }

  void setCallback(Function pCallback) {
    this._callback = pCallback;
  }

  void loadMore() {
    print("LOAD MORE");
    if (!this._isFinished) {
      this.listen();
    }
  }

  ScrollController get scrollController {
    return this._scrollController;
  }

  void finish() {
    this._isFinished = true;
  }

  void listen() {
    this._streamSubscription = this._stream.listen((QuerySnapshot pQuery) {
      print(pQuery.documents.length);
      if (pQuery.documents.length == 0) {
        return;
      } else if (pQuery.documents.length <= this._stepSize) {
        this._isFinished = true;
      }
      this._lastDocument = pQuery.documents.last;
      this._callback(pQuery);
    });
  }

  void scrollToTop() {
    this._scrollController.animateTo(
          0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
  }

  void cancel() {
    this._streamSubscription.cancel();
  }

  void dispose() {
    this.cancel();
  }

  //***************************************************//
  //*********   SETTER
  //***************************************************//

  set lastDocument(DocumentSnapshot pSnap) {
    this._lastDocument = pSnap;
  }

  set stream(Stream<QuerySnapshot> pStream) {
    this._stream = pStream;
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  bool get isFinished {
    return this._isFinished;
  }

  int get stepSize {
    return this._stepSize;
  }

  DocumentSnapshot get lastDocument {
    return this._lastDocument;
  }
}
