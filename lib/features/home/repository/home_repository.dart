import 'dart:io';

class HomeRepository {
  Future<String> uploadImage(File image) async {
    // Giả lập gửi ảnh và trả về URL ảnh
    await Future.delayed(Duration(seconds: 2));
    return 'https://picsum.photos/200/200?random=${DateTime.now().millisecondsSinceEpoch}';
  }
}
