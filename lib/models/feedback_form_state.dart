import 'package:flutter/foundation.dart';
import 'media_file.dart';

class FeedbackFormState extends ChangeNotifier {
  String selectedProduct = '';
  String selectedUnityVersion = '';
  String otherUnityVersion = '';
  String bugTitle = '';
  String bugDescription = '';
  List<MediaFile> mediaFiles = [];
  bool showDocumentationBox = true;

  void updateProduct(String value) {
    selectedProduct = value;
    notifyListeners();
  }

  void updateUnityVersion(String value) {
    selectedUnityVersion = value;
    notifyListeners();
  }

  void updateOtherUnityVersion(String value) {
    otherUnityVersion = value;
    notifyListeners();
  }

  void updateBugTitle(String value) {
    bugTitle = value;
    notifyListeners();
  }

  void updateBugDescription(String value) {
    bugDescription = value;
    notifyListeners();
  }

  void addMediaFiles(List<MediaFile> files) {
    mediaFiles.addAll(files);
    notifyListeners();
  }

  void removeMediaFile(MediaFile file) {
    mediaFiles.remove(file);
    notifyListeners();
  }

  void hideDocumentationBox() {
    showDocumentationBox = false;
    notifyListeners();
  }

  void resetForm() {
    selectedProduct = '';
    selectedUnityVersion = '';
    otherUnityVersion = '';
    bugTitle = '';
    bugDescription = '';
    mediaFiles = [];
    showDocumentationBox = true;
    notifyListeners();
  }

  bool get isFormValid {
    final bool isUnityVersionValid = selectedUnityVersion.isNotEmpty &&
        (selectedUnityVersion != 'other' || otherUnityVersion.isNotEmpty);
    
    final bool isTitleValid = bugTitle.isNotEmpty && bugTitle.split(' ').length <= 4;
    final bool isDescriptionValid = bugDescription.length >= 150;
    final bool areMediaFilesValid = mediaFiles.length >= 2;

    return selectedProduct.isNotEmpty &&
        isUnityVersionValid &&
        isTitleValid &&
        isDescriptionValid &&
        areMediaFilesValid;
  }
}