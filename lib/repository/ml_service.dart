import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dapenda/app/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;

import 'image_converter.dart';

class MLService {
  Interpreter? _interpreter;
  double threshold = 0.6;
  double threshold2 = 0.8;

  List _predictedData = [];
  List get predictedData => _predictedData;

  Future<Interpreter> initialize() async {
    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
            inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
            inferencePriority1: TfLiteGpuInferencePriority.minLatency,
            inferencePriority2: TfLiteGpuInferencePriority.auto,
            inferencePriority3: TfLiteGpuInferencePriority.auto,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
            allowPrecisionLoss: true,
            waitType: TFLGpuDelegateWaitType.active,
          ),
        );
      }

      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);

      _interpreter = await Interpreter.fromAsset(
        'mobilefacenet.tflite',
        options: interpreterOptions,
      );
      print(_interpreter);
      print('Interpreter created with GPU delegate');
    } catch (e) {
      print('Failed to load model with GPU delegate.');
      print(e);

      // Fallback to CPU
      try {
        var interpreterOptions = InterpreterOptions();
        _interpreter = await Interpreter.fromAsset(
          'mobilefacenet.tflite',
          options: interpreterOptions,
        );

        print('Interpreter created with CPU fallback');
      } catch (e) {
        print('Failed to load model with CPU fallback.');
        print(e);
      }
    }
    return _interpreter!;
  }

  Future<List<double>> setCurrentPrediction(CameraImage cameraImage, Face? face,
      {required Interpreter interpreter}) async {
    // if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = _preProcess(cameraImage, face);

    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    interpreter.run(input, output);
    output = output.reshape([192]);

    _predictedData = List.from(output);

    return List.from(output);
  }

  Future<List<double>> setCurrentPredictionFile(imglib.Image image,
      {required Interpreter interpreter}) async {
    List input = imageToByteListFloat32(image);

    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    interpreter.run(input, output);
    output = output.reshape([192]);

    _predictedData = List.from(output);

    return List.from(output);
  }

  // Future<User?> predict() async {
  //   return _searchResult(this._predictedData);
  // }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
      convertedImage,
      x.round(),
      y.round(),
      w.round(),
      h.round(),
    );
  }

  imglib.Image convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  Future<bool> searchResult(List predictedData) async {
    // DatabaseHelper _dbHelper = DatabaseHelper.instance;

    // List<User> users = await _dbHelper.queryAllUsers();
    double minDist = 999;
    double currDist = 0.0;
    bool isRecognized = false;
    // User? predictedResult;

    // print('users.length=> ${users.length}');

    for (var item in dataDummyMatrik) {
      // print(item);
      // print(predictedData);
      currDist = _euclideanDistance(item, predictedData);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        isRecognized = true;
      }
    }
    print(minDist);
    return isRecognized;
  }

  Future<bool> searchResult2(List predictedData) async {
    // DatabaseHelper _dbHelper = DatabaseHelper.instance;

    // List<User> users = await _dbHelper.queryAllUsers();
    double minDist = 999;
    double currDist = 0.0;
    bool isRecognized = false;
    // User? predictedResult;

    // print('users.length=> ${users.length}');

    for (var item in dataDummyMatrik) {
      // print(item);
      // print(predictedData);
      currDist = _euclideanDistance(item, predictedData);
      if (currDist <= threshold2 && currDist < minDist) {
        minDist = currDist;
        isRecognized = true;
      }
    }
    print(minDist);
    return isRecognized;
  }

  double _euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }

    sum = sqrt(sum);
    print(sum);
    return sum;
  }

  void setPredictedData(value) {
    this._predictedData = value;
  }

  dispose() {}
}

Future<File> saveImageToFile(imglib.Image image, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/$fileName.png';
  final file = File(path);

  // Konversi image ke format PNG dan simpan
  final pngBytes = imglib.encodePng(image);
  await file.writeAsBytes(pngBytes);

  return file;
}
