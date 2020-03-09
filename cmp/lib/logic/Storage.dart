import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  StorageReference _ref;

  Storage() {
    this._ref = FirebaseStorage.instance.ref();
  }

  Future<String> uploadImage(File pImage, String pPath) async {
    StorageReference storageReference = this._ref.child(pPath);
    StorageUploadTask uploadTask = storageReference.putFile(pImage);
    StorageTaskSnapshot task = await uploadTask.onComplete;
    return await task.ref.getDownloadURL();
  }
}
