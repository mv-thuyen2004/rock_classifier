import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class RockClassifier {
  late Interpreter _interpreter;

  /// Load mô hình từ assets
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/test.tflite');
      print("✅ Model loaded");
    } catch (e) {
      print("❌ Failed to load model: $e");
    }
  }

  /// Dự đoán ảnh đã resize
  Future<Map<String, dynamic>> predict(img.Image image) async {
    // Resize ảnh về 224x224
    final resizedImage = img.copyResize(image, width: 224, height: 224);

    // Chuyển ảnh thành tensor 4D [1, 224, 224, 3]
    var input = List.generate(
        1,
        (_) => List.generate(
            224,
            (x) => List.generate(224, (y) {
                  final pixel = resizedImage.getPixel(x, y); // Pixel
                  final r = pixel.r / 255.0;
                  final g = pixel.g / 255.0;
                  final b = pixel.b / 255.0;

                  return [r, g, b];
                })));

    // Tạo mảng output
    var output = List.filled(1 * 7, 0.0).reshape([1, 7]);

    // Chạy mô hình
    _interpreter.run(input, output);

    // Lấy chỉ số nhãn có xác suất cao nhất
    List<double> predictions = output[0];
    int predictedIndex = predictions
        .indexWhere((e) => e == predictions.reduce((a, b) => a > b ? a : b));
    double confidence = predictions[predictedIndex];

    // Giải phóng bộ nhớ mô hình sau khi sử dụng
    _interpreter.close();
    print("✅ Model resources released successfully.");

    return {
      "predictedIndex": predictedIndex, // Trả về chỉ số nhãn dự đoán
      "confidence": confidence, // Trả về xác suất
      "raw": predictions, // Trả về kết quả dự đoán thô
    };
  }
}
