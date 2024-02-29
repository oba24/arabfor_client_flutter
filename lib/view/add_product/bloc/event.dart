import 'dart:io';

class AddProductEvent {}

class StartAddProductEvent extends AddProductEvent {
  late List<File> images;
  Map<String, dynamic> toJson() => {};

  StartAddProductEvent() {
    images = [File("https://www.remove.bg/images/remove_image_background.jpg")];
  }
}
