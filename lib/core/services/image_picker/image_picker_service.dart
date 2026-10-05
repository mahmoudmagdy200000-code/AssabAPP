import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ImagePickerService {
  final ImagePicker _picker;

  const ImagePickerService(this._picker);

  Future<XFile?> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      return pickedFile;
    } catch (_) {
      return null;
    }
  }
}
