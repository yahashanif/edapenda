// import 'dart:math';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:dapenda/app/constant.dart';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// import '../model/Recognition.dart';
// // import '../DB/DatabaseHelper.dart';
// // import 'Recognition.dart';

// class Recognizer2 {
//   late Interpreter interpreter;
//   late InterpreterOptions _interpreterOptions;
//   static const int WIDTH = 112;
//   static const int HEIGHT = 112;
//   // final dbHelper = DatabaseHelper();
//   Map<String, Recognition> registered = Map();
//   @override
//   String get modelName => 'assets/mobile_face_net.tflite';

//   Recognizer2({int? numThreads}) {
//     _interpreterOptions = InterpreterOptions();

//     if (numThreads != null) {
//       _interpreterOptions.threads = numThreads;
//     }
//     loadModel();
//     initDB();
//   }

//   initDB() async {
//     // await dbHelper.init();
//     // loadRegisteredFaces();
//   }

//   // void loadRegisteredFaces() async {
//   //   registered.clear();
//   //   final allRows = await dbHelper.queryAllRows();
//   //   // debugPrint('query all rows:');
//   //   for (final row in allRows) {
//   //     //  debugPrint(row.toString());
//   //     print(row[DatabaseHelper.columnName]);
//   //     String name = row[DatabaseHelper.columnName];
//   //     List<double> embd = row[DatabaseHelper.columnEmbedding]
//   //         .split(',')
//   //         .map((e) => double.parse(e))
//   //         .toList()
//   //         .cast<double>();
//   //     Recognition recognition =
//   //         Recognition(row[DatabaseHelper.columnName], Rect.zero, embd, 0);
//   //     registered.putIfAbsent(name, () => recognition);
//   //     print("R=" + name);
//   //   }
//   // }

//   void registerFaceInDB(String name, List<double> embedding) async {
//     // row to insert
//     // Map<String, dynamic> row = {
//     //   DatabaseHelper.columnName: name,
//     //   DatabaseHelper.columnEmbedding: embedding.join(",")
//     // };
//     // final id = await dbHelper.insert(row);
//     dataDummyMatrik.add(embedding);
//     // print('inserted row id: $id');
//     // loadRegisteredFaces();
//   }

//   Future<void> loadModel() async {
//     try {
//       interpreter = await Interpreter.fromAsset(modelName);
//     } catch (e) {
//       print('Unable to create interpreter, Caught Exception: ${e.toString()}');
//     }
//   }

//   List<dynamic> imageToArray(img.Image inputImage) {
//     img.Image resizedImage =
//         img.copyResize(inputImage!, width: WIDTH, height: HEIGHT);
//     List<double> flattenedList = resizedImage.data!
//         .expand((channel) => [channel.r, channel.g, channel.b])
//         .map((value) => value!.toDouble())
//         .toList();
//     Float32List float32Array = Float32List.fromList(flattenedList);
//     int channels = 3;
//     int height = HEIGHT;
//     int width = WIDTH;
//     Float32List reshapedArray = Float32List(1 * height * width * channels);
//     for (int c = 0; c < channels; c++) {
//       for (int h = 0; h < height; h++) {
//         for (int w = 0; w < width; w++) {
//           int index = c * height * width + h * width + w;
//           reshapedArray[index] =
//               (float32Array[c * height * width + h * width + w] - 127.5) /
//                   127.5;
//         }
//       }
//     }
//     return reshapedArray.reshape([1, 112, 112, 3]);
//   }

//   Recognition recognize2(
//       img.Image image, Rect location, List<List<double>> data) {
//     //TODO crop face from image resize it and convert it to float array
//     var input = imageToArray(image);
//     print(input.shape.toString());

//     //TODO output array
//     List output = List.filled(1 * 192, 0).reshape([1, 192]);

//     //TODO performs inference
//     final runs = DateTime.now().millisecondsSinceEpoch;
//     interpreter.run(input, output);
//     final run = DateTime.now().millisecondsSinceEpoch - runs;
//     print('Time to run inference: $run ms$output');

//     //TODO convert dynamic list to double list
//     List<double> outputArray = output.first.cast<double>();

//     //TODO looks for the nearest embeeding in the database and returns the pair
//     Pair pair = findNearest2(outputArray);

//     print("distance= ${pair.distance}");

//     return Recognition(pair.name, location, outputArray, pair.distance);
//   }

//   //TODO  looks for the nearest embeeding in the database and returns the pair which contain information of registered face with which face is most similar

//   Pair findNearest2(List<double> emb) {
//     List<double> temp = [];
//     Pair pair = Pair("Unknown", -5); // Ubah -5 menjadi double.infinity
//     for (int knownEmb = 0; knownEmb < dataDummyMatrik.length; knownEmb++) {
//       print("Known vector length: ${dataDummyMatrik[knownEmb].length}");
//       print("Input vector length: ${emb.length}");

//       if (dataDummyMatrik[knownEmb].length != emb.length) {
//         print("Dimension mismatch");
//         continue; // Skip if dimensions do not match
//       }

//       double distance = 0;
//       for (int i = 0; i < emb.length; i++) {
//         double diff = emb[i] - dataDummyMatrik[knownEmb][i];
//         distance += diff * diff;
//       }
//       print(knownEmb);
//       distance = sqrt(distance);
//       print("Distance to known vector $knownEmb: $distance");
//       // if (distance < pair.distance) {
//       //   pair.distance = distance;
//       //   pair.name = "Dikenali";
//       // }
//       if (pair.distance == -5 || distance < pair.distance) {
//         pair.distance = distance;
//         pair.name = "Dikenali";
//       }
//     }

//     if (pair.distance == double.infinity) {
//       pair.name =
//           "Tidak Dikenali"; // Set the name to "Tidak Dikenali" if no match was found
//     }

//     print("Distance: ${pair.distance}");
//     print("Name: ${pair.name}");
//     return pair;
//   }

//   double cosineSimilarity(List<double> vecA, List<double> vecB) {
//     if (vecA.length != vecB.length) {
//       throw ArgumentError('Vectors must be of the same length');
//     }

//     double dotProduct = 0.0;
//     double magnitudeA = 0.0;
//     double magnitudeB = 0.0;

//     for (int i = 0; i < vecA.length; i++) {
//       dotProduct += vecA[i] * vecB[i];
//       magnitudeA += vecA[i] * vecA[i];
//       magnitudeB += vecB[i] * vecB[i];
//     }

//     magnitudeA = sqrt(magnitudeA);
//     magnitudeB = sqrt(magnitudeB);

//     if (magnitudeA == 0 || magnitudeB == 0) {
//       return 0.0; // Handle edge case where one of the vectors is a zero vector
//     }

//     return dotProduct / (magnitudeA * magnitudeB);
//   }

//   void close() {
//     interpreter.close();
//   }
// }

// class Pair {
//   String name;
//   double distance;
//   Pair(this.name, this.distance);
// }
