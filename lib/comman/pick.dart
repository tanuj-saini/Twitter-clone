
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:twitter/features/auth/login.dart';

Future<FilePickerResult?> pickkImage()async{
      final image= await FilePicker.platform.pickFiles(type:FileType.image);
      return image;
      


    }

 Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
   gif= await Giphy.getGif(context: context, apiKey: '9Id3AaevlpsJ4b2zi6vTA0izJvLorImH');
  } catch (e) {
    showSnackBar(e.toString(),context);
  }
  return gif;
}
