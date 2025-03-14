import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dapenda/cubit/value_pendataan_foto_cubit/value_pendataan_foto_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'
    // ignore: library_prefixes
    as faceD;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:image/image.dart' as img;
import 'package:liveness_detection_flutter_plugin/index.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../app/constant.dart';
import '../../cubit/image_cubit/current_image_cubit.dart';
import '../../main.dart';
import '../../model/Recognition.dart';
import '../../repository/Recognizer.dart';
import '../../repository/ml_service.dart';

class PendataanCameraScreen extends StatefulWidget {
  const PendataanCameraScreen({super.key});

  @override
  State<PendataanCameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<PendataanCameraScreen> {
  late faceD.FaceDetector faceDetector;
  List<faceD.Face> faces = [];
  // late Recognizer recognizer;
  late Future<void> _initializeControllerFuture;

  late CameraController controller;
  int index = 1;
  var image;
  Interpreter? _interpreter;
  bool _processing = false;

  Future<bool> initializeCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(
        cameras[index],
        imageFormatGroup: ImageFormatGroup.yuv420,
        ResolutionPreset.low);
    print("CEk Status Camera");
    print(controller.value.isInitialized);
    await controller.initialize();

    controller.startImageStream((image) async {
      if (_processing == true) {
        _cameraImageToInputImage(image);
        controller.stopImageStream();
      }
    });

    return controller.value.isInitialized;
  }

  _initializeInterpreter() async {
    _interpreter = await MLService().initialize();
  }

  Future<void> _cameraImageToInputImage(CameraImage cameraImage) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());
    final imageRotation = InputImageRotationValue.fromRawValue(
      cameras[index].sensorOrientation,
    );
    final inputImageFormat = InputImageFormatValue.fromRawValue(
      cameraImage.format.raw,
    );

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        print(plane.width);
        return InputImageMetadata(
          bytesPerRow: plane.bytesPerRow,
          size: Size(plane.width == null ? 0 : plane.width!.toDouble(),
              plane.height == null ? 0 : plane.height!.toDouble()),
          rotation: imageRotation!,
          format: inputImageFormat!,
        );
      },
    ).toList();

    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation!,
      format: inputImageFormat!,
      bytesPerRow: planeData.first.bytesPerRow,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    // if (dataDummyMatrik.length < 3) {
    //   await Future.delayed(const Duration(seconds: 2)).then((value) async {
    Face face = await _processImage(inputImage);

    MLService()
        .setCurrentPrediction(cameraImage, face, interpreter: _interpreter!)
        .then((result) {
      print(result);
      context.read<ValuePendataanFotoCubit>().setValue(result);
      listAPIDummy.clear();
      listAPIDummy = result;

      // dataDummyMatrik.add(result);
    });

    img.Image dataImage = MLService().convertCameraImage(cameraImage);

    var dataFile = await saveImageToFile(dataImage, DateTime.now().toString());
    // ignore: use_build_context_synchronously
    context.read<CurrentImageCubit>().setXFile(XFile(dataFile.path));

    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    setState(() {});
    // });
    // } else {
    //   controller.stopImageStream();
    // }
  }

  Future<Face> _processImage(InputImage inputImage) async {
    // if (_isProcessing) return;
    // setState(() {
    //   _isProcessing = true;
    // });
    final faceDetector = GoogleMlKit.
        // ignore: deprecated_member_use
        vision
        .faceDetector(FaceDetectorOptions(
            enableLandmarks: true,
            enableContours: true,
            performanceMode: FaceDetectorMode.fast));

    print("faceDetector");
    print(faceDetector);
    print(await faceDetector.processImage(inputImage));
    final List<Face> faces = await faceDetector.processImage(inputImage);

    // final faces =
    //     await MachineLearningHelper.instance.processInputImage(inputImage);
    print(faces.length);

    if (faces.isEmpty) {
      dataDummyMatrik.clear();
      print("NO FACES");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Tidak ada wajah yang terdeteksi\n Coba lagi")));
      Navigator.pop(context);
      throw Exception('Face is null');
    } else {
      final firstFace = faces.first;

      // if (dataDummyMatrik.length > 20) {
      //   _isProcessing = false;
      //   controller.stopImageStream();
      //   setState(() {});
      //   // return;
      // }

      // await Future.delayed(const Duration(microseconds: 20))
      //     .then((value) async {
      //   try {
      //     final XFile imageFile = await controller.takePicture();
      //     // List<double> dataTemp = await getRecog(File(imageFile.path));
      //     // dataTemp2.add(dataTemp[0]);
      //     // dataDummyMatrik.add(dataTemp);
      //     // final hasil = Recognizer2().findNearest2(widget.embedding);
      //     // textCheck = hasil.distance < 0.1 ? "Dikenali" : "Tidak Dikenali";
      //     setState(() {});
      //   } catch (e) {
      //     print('Error taking picture: $e');
      //   } finally {
      //     setState(() {
      //       _isProcessing = false;
      //     });
      //   }
      // });
      return firstFace;
    }
  }

  Future<File> takePicture() async {
    XFile? data;
    try {
      data = await controller.takePicture();
    } catch (e) {
      // return null;
    }

    return File(data!.path);
  }

  @override
  void initState() {
    // TODO: implement initState
    _initializeInterpreter();
    super.initState();
    // final options = faceD.FaceDetectorOptions(
    //     performanceMode: faceD.FaceDetectorMode.accurate);
    // faceDetector = faceD.FaceDetector(options: options);
    // recognizer = Recognizer();
    _initializeControllerFuture = initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.dispose();
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (_, snapshot) {
                return (snapshot.connectionState == ConnectionState.done)
                    ? Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [CameraPreview(controller)],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width *
                                    controller.value.aspectRatio,
                                // height: controller.value.aspectRatio * 500,
                                child: Image.asset(
                                  'assets/images/layer.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      // height: 80,
                                      // margin: EdgeInsets.only(top: 50),
                                    ),
                                    Container(
                                      width: 80,
                                      // height: 80,
                                      margin: EdgeInsets.only(top: 20),
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _processing = true;
                                          });
                                          // File result = await takePicture();
                                          // print(result);

                                          // var hasil =
                                          //     await doFaceDetection(result);
                                          // // final hasil = Recognizer()
                                          // //     .areMatching(widget.embedding,
                                          // //         recognition2.embeddings, 1);
                                          // print("hasil");
                                          // print(hasil);
                                          // if (hasil.isNotEmpty) {
                                          // context
                                          //     .read<ValuePendataanFotoCubit>()
                                          //     .setValue(hasil);
                                          // context
                                          //     .read<CurrentImageCubit>()
                                          //     .setXFile(XFile(result.path));
                                          //   Navigator.pop(context);
                                          // }
                                        },
                                        child: Icon(
                                          Icons.circle,
                                          color: Colors.white,
                                          size: getActualY(
                                              y: 80, context: context),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      // height: 70,
                                      margin: EdgeInsets.only(top: 20),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              })),
    );
  }

  // Future<List<double>> doFaceDetection(File file) async {
  //   //TODO remove rotation of camera images

  //   InputImage inputImage = InputImage.fromFile(file);

  //   // image = await _image?.readAsBytes();
  //   image = await decodeImageFromList(file!.readAsBytesSync());
  //   //TODO passing input to face detector and getting detected faces
  //   faces = await faceDetector.processImage(inputImage);

  //   // for (Face face in faces) {
  //   final Rect boundingBox = faces[0].boundingBox;

  //   print("Rect " + boundingBox.toString());

  //   num left = boundingBox.left < 0 ? 0 : boundingBox.left;
  //   num top = boundingBox.top < 0 ? 0 : boundingBox.top;
  //   num right =
  //       boundingBox.right > image.width ? image.width - 1 : boundingBox.right;
  //   num bottom = boundingBox.bottom > image.height
  //       ? image.height - 1
  //       : boundingBox.bottom;
  //   num width = right - left;
  //   num height = bottom - top;

  //   final bytes = file.readAsBytesSync();
  //   img.Image? faceImg = img.decodeImage(bytes);
  //   img.Image? croppedFace = img.copyCrop(
  //       faceImg!, left.toInt(), top.toInt(), width.toInt(), height.toInt());

  //   // List<double> recog = recognizer.recog(croppedFace, boundingBox);
  //   print("recog");
  //   print(recog);

  //   return recog;
  //   // showFaceRegistrationDialogue(
  //   //     Uint8List.fromList(img.encodeBmp(croppedFace)), recognition);
  //   // }

  //   // drawRectangleAroundFaces();

  //   //TODO call the method to perform face recognition on detected faces
  // }
}






// // 
// class CameraScreen extends StatefulWidget {
//   final List<double> embedding;

//   const CameraScreen({super.key, required this.embedding});
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   dynamic controller;
//   bool isBusy = false;
//   late Size size;
//   late CameraDescription description;
//   CameraLensDirection camDirec = CameraLensDirection.front;
//   late List<Recognition> recognitions = [];

//   //TODO declare face detector
//   late FaceDetector faceDetector;

//   //TODO declare face recognizer
//   late Recognizer recognizer;

//   initCamera() async {
//     cameras = await availableCameras();
//     await Future.delayed(Duration(seconds: 2)).then((value) {
//       initializeCamera();
//     });

//     return true;
//   }

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(seconds: 2)).then((value) {
//       initCamera();

//       description = cameras[1];
//       //TODO initialize face detector
//       var options =
//           FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate);
//       faceDetector = FaceDetector(options: options);
//       //TODO initialize face recognizer
//       recognizer = Recognizer();
//     });
//     //TODO initialize camera footage
//   }

//   //TODO code to initialize the camera feed
//   initializeCamera() async {
//     controller = CameraController(description, ResolutionPreset.medium,
//         imageFormatGroup: Platform.isAndroid
//             ? ImageFormatGroup.nv21 // for Android
//             : ImageFormatGroup.bgra8888,
//         enableAudio: false); // for iOS);
//     await controller.initialize().then((_) {
//       // if (!mounted) {
//       //   return;
//       // }
//       controller.startImageStream((image) => {
//             if (!isBusy)
//               {isBusy = true, frame = image, doFaceDetectionOnFrame()}
//           });
//     });
//   }

//   //TODO close all resources
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   //TODO face detection on a frame
//   dynamic _scanResults;
//   CameraImage? frame;
//   doFaceDetectionOnFrame() async {
//     //TODO convert frame into InputImage format
//     print('dfd');
//     InputImage? inputImage = getInputImage();
//     //TODO pass InputImage to face detection model and detect faces
//     List<Face> faces = await faceDetector.processImage(inputImage!);

//     print("fl=" + faces.length.toString());
//     //TODO perform face recognition on detected faces
//     performFaceRecognition(faces);
//     // setState(() {
//     //   _scanResults = faces;
//     //   isBusy = false;
//     // });
//   }

//   img.Image? image;
//   bool register = false;
//   // TODO perform Face Recognition
//   performFaceRecognition(List<Face> faces) async {
//     recognitions.clear();

//     //TODO convert CameraImage to Image and rotate it so that our frame will be in a portrait
//     image = Platform.isIOS
//         ? _convertBGRA8888ToImage(frame!) as img.Image?
//         : _convertNV21(frame!);
//     image = img.copyRotate(image!,
//         angle: camDirec == CameraLensDirection.front ? 270 : 90);

//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//       //TODO crop face
//       img.Image croppedFace = img.copyCrop(image!,
//           x: faceRect.left.toInt(),
//           y: faceRect.top.toInt(),
//           width: faceRect.width.toInt(),
//           height: faceRect.height.toInt());

//       //TODO pass cropped face to face recognition model
//       Recognition recognition =
//           recognizer.recognize(croppedFace!, faceRect, widget.embedding);
//       if (recognition.distance > 1.0) {
//         recognition.name = "Unknown";
//       }
//       recognitions.add(recognition);

//       //TODO show face registration dialogue
//       if (register) {
//         showFaceRegistrationDialogue(croppedFace!, recognition);
//         register = false;
//       }
//     }

//     setState(() {
//       isBusy = false;
//       _scanResults = recognitions;
//     });
//   }

//   //TODO Face Registration Dialogue
//   TextEditingController textEditingController = TextEditingController();
//   showFaceRegistrationDialogue(img.Image croppedFace, Recognition recognition) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Face Registration", textAlign: TextAlign.center),
//         alignment: Alignment.center,
//         content: SizedBox(
//           height: 340,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: 20,
//               ),
//               Image.memory(
//                 Uint8List.fromList(img.encodeBmp(croppedFace!)),
//                 width: 200,
//                 height: 200,
//               ),
//               SizedBox(
//                 width: 200,
//                 child: TextField(
//                     controller: textEditingController,
//                     decoration: const InputDecoration(
//                         fillColor: Colors.white,
//                         filled: true,
//                         hintText: "Enter Name")),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     initCamera();
//                     initializeCamera();
//                     setState(() {});
//                     // recognizer.registerFaceInDB(
//                     //     textEditingController.text, recognition.embeddings);
//                     // textEditingController.text = "";
//                     // Navigator.pop(context);
//                     // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     //   content: Text("Face Registered"),
//                     // ));
//                   },
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       minimumSize: const Size(200, 40)),
//                   child: const Text("Register"))
//             ],
//           ),
//         ),
//         contentPadding: EdgeInsets.zero,
//       ),
//     );
//   }

//   static var IOS_BYTES_OFFSET = 28;

//   static img.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
//     final plane = cameraImage.planes[0];

//     return img.Image.fromBytes(
//       width: cameraImage.width,
//       height: cameraImage.height,
//       bytes: plane.bytes.buffer,
//       rowStride: plane.bytesPerRow,
//       bytesOffset: IOS_BYTES_OFFSET,
//       order: img.ChannelOrder.bgra,
//     );
//   }

//   static img.Image _convertNV21(CameraImage image) {
//     final width = image.width.toInt();
//     final height = image.height.toInt();

//     Uint8List yuv420sp = image.planes[0].bytes;

//     final outImg = img.Image(height: height, width: width);
//     final int frameSize = width * height;

//     for (int j = 0, yp = 0; j < height; j++) {
//       int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
//       for (int i = 0; i < width; i++, yp++) {
//         int y = (0xff & yuv420sp[yp]) - 16;
//         if (y < 0) y = 0;
//         if ((i & 1) == 0) {
//           v = (0xff & yuv420sp[uvp++]) - 128;
//           u = (0xff & yuv420sp[uvp++]) - 128;
//         }
//         int y1192 = 1192 * y;
//         int r = (y1192 + 1634 * v);
//         int g = (y1192 - 833 * v - 400 * u);
//         int b = (y1192 + 2066 * u);

//         if (r < 0)
//           r = 0;
//         else if (r > 262143) r = 262143;
//         if (g < 0)
//           g = 0;
//         else if (g > 262143) g = 262143;
//         if (b < 0)
//           b = 0;
//         else if (b > 262143) b = 262143;

//         // I don't know how these r, g, b values are defined, I'm just copying what you had bellow and
//         // getting their 8-bit values.
//         outImg.setPixelRgb(i, j, ((r << 6) & 0xff0000) >> 16,
//             ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff);
//       }
//     }
//     return outImg;
//   }

//   // TODO method to convert CameraImage to Image
//   img.Image convertYUV420ToImage(CameraImage cameraImage) {
//     final width = cameraImage.width;
//     final height = cameraImage.height;

//     final yRowStride = cameraImage.planes[0].bytesPerRow;
//     final uvRowStride = cameraImage.planes[1].bytesPerRow;
//     final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

//     final image = img.Image(width: width, height: height);

//     for (var w = 0; w < width; w++) {
//       for (var h = 0; h < height; h++) {
//         final uvIndex =
//             uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
//         final index = h * width + w;
//         final yIndex = h * yRowStride + w;

//         final y = cameraImage.planes[0].bytes[yIndex];
//         final u = cameraImage.planes[1].bytes[uvIndex];
//         final v = cameraImage.planes[2].bytes[uvIndex];

//         image.data!.setPixelR(w, h, yuv2rgb(y, u, v)); //= yuv2rgb(y, u, v);
//       }
//     }
//     return image;
//   }

//   int yuv2rgb(int y, int u, int v) {
//     // Convert yuv pixel to rgb
//     var r = (y + v * 1436 / 1024 - 179).round();
//     var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
//     var b = (y + u * 1814 / 1024 - 227).round();

//     // Clipping RGB values to be inside boundaries [ 0 , 255 ]
//     r = r.clamp(0, 255);
//     g = g.clamp(0, 255);
//     b = b.clamp(0, 255);

//     return 0xff000000 |
//         ((b << 16) & 0xff0000) |
//         ((g << 8) & 0xff00) |
//         (r & 0xff);
//   }

//   final _orientations = {
//     DeviceOrientation.portraitUp: 0,
//     DeviceOrientation.landscapeLeft: 90,
//     DeviceOrientation.portraitDown: 180,
//     DeviceOrientation.landscapeRight: 270,
//   };

//   //TODO convert CameraImage to InputImage
//   InputImage? getInputImage() {
//     final camera =
//         camDirec == CameraLensDirection.front ? cameras[1] : cameras[0];
//     final sensorOrientation = camera.sensorOrientation;

//     InputImageRotation? rotation;
//     if (Platform.isIOS) {
//       rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
//     } else if (Platform.isAndroid) {
//       var rotationCompensation =
//           _orientations[controller!.value.deviceOrientation];
//       if (rotationCompensation == null) return null;
//       if (camera.lensDirection == CameraLensDirection.front) {
//         // front-facing
//         rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
//       } else {
//         // back-facing
//         rotationCompensation =
//             (sensorOrientation - rotationCompensation + 360) % 360;
//       }
//       rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
//     }
//     if (rotation == null) return null;

//     final format = InputImageFormatValue.fromRawValue(frame!.format.raw);
//     if (format == null ||
//         (Platform.isAndroid && format != InputImageFormat.nv21) ||
//         (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

//     if (frame!.planes.length != 1) return null;
//     final plane = frame!.planes.first;

//     return InputImage.fromBytes(
//       bytes: plane.bytes,
//       inputImageData: InputImageData(
//           size: Size(frame!.width.toDouble(), frame!.height.toDouble()),
//           imageRotation: rotation,
//           inputImageFormat: format,
//           planeData: plane.bytesPerRow != null
//               ? [
//                   InputImagePlaneMetadata(
//                       bytesPerRow: plane.bytesPerRow,
//                       height: plane.height,
//                       width: plane.width)
//                 ]
//               : null),
//     );
//   }

//   Widget buildResult() {
//     // if (_scanResults == null ||
//     //     controller == null ||
//     //     !controller.value.isInitialized) {
//     //   return const Center(child: Text('Camera is not initialized'));
//     // }
//     final Size imageSize = Size(
//       controller.value.previewSize!.height,
//       controller.value.previewSize!.width,
//     );
//     CustomPainter painter =
//         FaceDetectorPainter(imageSize, _scanResults, camDirec);
//     return CustomPaint(
//       painter: painter,
//     );
//   }

//   //TODO toggle camera direction
//   void _toggleCameraDirection() async {
//     if (camDirec == CameraLensDirection.back) {
//       camDirec = CameraLensDirection.front;
//       description = cameras[1];
//     } else {
//       camDirec = CameraLensDirection.back;
//       description = cameras[0];
//     }
//     await controller.stopImageStream();
//     setState(() {
//       controller;
//     });

//     initializeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> stackChildren = [];
//     size = MediaQuery.of(context).size;
//     if (controller != null) {
//       //TODO View for displaying the live camera footage
//       stackChildren.add(
//         Positioned(
//           top: 0.0,
//           left: 0.0,
//           width: size.width,
//           height: size.height,
//           child: Container(
//             child: (controller.value.isInitialized)
//                 ? AspectRatio(
//                     aspectRatio: controller.value.aspectRatio,
//                     child: CameraPreview(controller),
//                   )
//                 : Container(),
//           ),
//         ),
//       );

//       //TODO View for displaying rectangles around detected aces
//       stackChildren.add(
//         Positioned(
//             top: 0.0,
//             left: 0.0,
//             width: size.width,
//             height: size.height,
//             child: buildResult()),
//       );
//     }

//     //TODO View for displaying the bar to switch camera direction or for registering faces
//     stackChildren.add(Positioned(
//       top: size.height - 140,
//       left: 0,
//       width: size.width,
//       height: 80,
//       child: Card(
//         margin: const EdgeInsets.only(left: 20, right: 20),
//         color: Colors.blue,
//         child: Center(
//           child: Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.cached,
//                         color: Colors.white,
//                       ),
//                       iconSize: 40,
//                       color: Colors.black,
//                       onPressed: () {
//                         _toggleCameraDirection();
//                       },
//                     ),
//                     Container(
//                       width: 30,
//                     ),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.face_retouching_natural,
//                         color: Colors.white,
//                       ),
//                       iconSize: 40,
//                       color: Colors.black,
//                       onPressed: () {
//                         setState(() {
//                           register = true;
//                         });
//                       },
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));

//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: Colors.black,
//           body: Container(
//               margin: const EdgeInsets.only(top: 0),
//               color: Colors.black,
//               child: Stack(
//                 children: stackChildren,
//               ))),
//     );
//   }
// }

// class FaceDetectorPainter extends CustomPainter {
//   FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);

//   final Size absoluteImageSize;
//   final List<Recognition> faces;
//   CameraLensDirection camDire2;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double scaleX = size.width / absoluteImageSize.width;
//     final double scaleY = size.height / absoluteImageSize.height;

//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0
//       ..color = Colors.indigoAccent;

//     for (Recognition face in faces) {
//       canvas.drawRect(
//         Rect.fromLTRB(
//           camDire2 == CameraLensDirection.front
//               ? (absoluteImageSize.width - face.location.right) * scaleX
//               : face.location.left * scaleX,
//           face.location.top * scaleY,
//           camDire2 == CameraLensDirection.front
//               ? (absoluteImageSize.width - face.location.left) * scaleX
//               : face.location.right * scaleX,
//           face.location.bottom * scaleY,
//         ),
//         paint,
//       );

//       TextSpan span = TextSpan(
//           style: const TextStyle(color: Colors.white, fontSize: 20),
//           text: "${face.name}  ${face.distance.toStringAsFixed(2)}");
//       TextPainter tp = TextPainter(
//           text: span,
//           textAlign: TextAlign.left,
//           textDirection: TextDirection.ltr);
//       tp.layout();
//       tp.paint(canvas,
//           Offset(face.location.left * scaleX, face.location.top * scaleY));
//     }
//   }

//   @override
//   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
//     return true;
//   }
// }
