import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dapenda/cubit/count_otentication_cubit/count_otentication_cubit.dart';
import 'package:dapenda/cubit/pendataan_foto_matrik_cubit/pendataan_foto_matrik_cubit.dart';
import 'package:dapenda/repository/ml_service.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:liveness_detection_flutter_plugin/index.dart';
import 'package:path/path.dart' show join;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'
    as faceD;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../app/constant.dart';
import '../../app/routes.dart';
import '../../cubit/image_cubit/current_image_cubit.dart';
import '../../cubit/value_pendataan_foto_cubit/value_pendataan_foto_cubit.dart';
import '../../main.dart';
import '../../model/Recognition.dart';
import '../../repository/Recognizer.dart';
import '../../repository/Recognizer2.dart';

int index = 1;

class CameraScreen extends StatefulWidget {
  final List<double> embedding;

  const CameraScreen({super.key, required this.embedding});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  TextEditingController dataController = TextEditingController();
  late Future<void> _initializeControllerFuture;
  late faceD.FaceDetector faceDetector;
  List<faceD.Face> faces = [];
  bool init = true;
  String textCheck = '';
  // late Recognizer2 recognizer;
  // late Recognizer recognizer1;
  bool _isProcessing = false;

  late CameraController controller;
  var image;
  late Recognition recognition1;
  late Recognition recognition2;
  List<double> dataTemp2 = [];
  Interpreter? _interpreter;

  Future<bool> initializeCamera() async {
    dataDummyMatrik.clear();
    var cameras = await availableCameras();
    controller = CameraController(
        cameras[index],
        imageFormatGroup: ImageFormatGroup.yuv420,
        ResolutionPreset.low);
    await controller.initialize();
    await controller.startImageStream((image) async {
      // Future.delayed(Duration(seconds: 2)).then((value) {});
      if (_isProcessing == true) {
        _cameraImageToInputImage(image);
        controller.stopImageStream();
      }
    });

    init = false;
    return controller.value.isInitialized;
  }

  Future<void> _cameraImageToInputImage(CameraImage cameraImage) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());
    final inputImageFormat = InputImageFormatValue.fromRawValue(
      cameraImage.format.raw,
    );
    final imageRotation = InputImageRotationValue.fromRawValue(
      cameras[index].sensorOrientation,
    );

    final planeData = cameraImage.planes.map(
      (Plane plane) {
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

    // if (dataDummyMatrik.isEmpty) {
    await Future.delayed(const Duration(seconds: 3)).then((value) async {
      Face face = await _processImage(inputImage);

      MLService()
          .setCurrentPrediction(cameraImage, face, interpreter: _interpreter!)
          .then((result) {
        print("result");
        print(result);

        dataDummyMatrik.add(result);
        context.read<ValuePendataanFotoCubit>().setValue(result);
      });
      setState(() {});
    });
    img.Image dataImage = MLService().convertCameraImage(cameraImage);

    var dataFile = await saveImageToFile(dataImage, DateTime.now().toString());
    // ignore: use_build_context_synchronously
    context.read<CurrentImageCubit>().setXFile(XFile(dataFile.path));
    // } else {
    //   controller.stopImageStream();
    // }
    Navigator.pop(context);

    setState(() {});
  }

  Future<Face> _processImage(InputImage inputImage) async {
    // if (_isProcessing) return;
    // setState(() {
    //   _isProcessing = true;
    // });

    final faces =
        await MachineLearningHelper.instance.processInputImage(inputImage);
    print(faces.length);

    if (faces.isEmpty) {
      dataDummyMatrik.clear();
      print("NO FACES");
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Tidak ada wajah yang terdeteksi\n Coba lagi")));
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
    try {
      final XFile data = await controller.takePicture();
      return File(data.path);
    } catch (e) {
      print('Error taking picture: $e');
      rethrow;
    }
  }

  _initializeInterpreter() async {
    _interpreter = await MLService().initialize();
  }

  @override
  void initState() {
    super.initState();
    _initializeInterpreter();
    dataDummyMatrik.clear();

    final options = faceD.FaceDetectorOptions(
        performanceMode: faceD.FaceDetectorMode.accurate);
    faceDetector = faceD.FaceDetector(options: options);
    // recognizer = Recognizer2();
    // recognizer1 = Recognizer();
    _initializeControllerFuture = initializeCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              child: Image.asset(
                                'assets/images/layer.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        // CustomButton(
                        //     text: "Ganti Kamera",
                        //     onPressed: () {
                        //       // setState(() {
                        //       index = index == 1 ? 0 : 1;
                        //       //   initializeCamera();
                        //       // });
                        //       Navigator.popAndPushNamed(context, cameraRoute,
                        //           arguments: widget.embedding);
                        //     }),
                        // TextFormField(
                        //   controller: dataController,
                        // ),
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
                                  ),
                                  BlocBuilder<PendataanFotoMatrikCubit,
                                      PendataanFotoMatrikState>(
                                    builder: (context, state) {
                                      if (state is PendataanFotoMatrikLoaded) {
                                        return _isProcessing
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Container(
                                                width: 80,
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      _isProcessing = true;
                                                    });
                                                    print(listAPIDummy);

                                                    // Future.delayed(
                                                    //         Duration(seconds: 1))
                                                    //     .then((value) {
                                                    //   MLService()
                                                    //       .searchResult(listAPIDummy)
                                                    //       .then((value) {
                                                    //     print("Hasil");
                                                    //     context
                                                    //         .read<
                                                    //             CountOtenticationCubit>()
                                                    //         .setValue();
                                                    //     if (context
                                                    //             .read<
                                                    //                 CountOtenticationCubit>()
                                                    //             .state <
                                                    //         3) {
                                                    //       if (value == false) {
                                                    //         Navigator.pop(context);
                                                    //       } else {}
                                                    //     } else {}
                                                    //     print(value);
                                                    //   });
                                                    // });
                                                    // dataController.text =
                                                    //     dataDummyMatrik
                                                    //         .toString();

                                                    // File result =
                                                    //     await takePicture();
                                                    // print(result);

                                                    // if (widget.embedding
                                                    //     .isNotEmpty) {
                                                    //   // Recognition
                                                    //   //     resultRecog =
                                                    //   //     await doFaceDetection(
                                                    //   //         result);

                                                    //   // if (dataDummyMatrik
                                                    //   //         .length >=
                                                    //   //     3) {
                                                    //   print(listAPIDummy);
                                                    //   print(
                                                    //       dataDummyMatrik[
                                                    //           5]);
                                                    //   final hasil =
                                                    //       Recognizer2()
                                                    //           .findNearest2(
                                                    //               widget
                                                    //                   .embedding);
                                                    //   print("hasil");
                                                    //   print(hasil);
                                                    //   // } else {
                                                    //   //   dataDummyMatrik.add(
                                                    //   //       resultRecog
                                                    //   //           .embeddings);
                                                    //   // }

                                                    //   controller
                                                    //       .stopImageStream();
                                                    // } else {
                                                    //   context
                                                    //       .read<
                                                    //           CurrentImageCubit>()
                                                    //       .setXFile(XFile(
                                                    //           result
                                                    //               .path));
                                                    //   Navigator.pop(
                                                    //       context);
                                                    // }
                                                  },
                                                  child: Icon(
                                                    Icons.circle,
                                                    color: Colors.white,
                                                    size: getActualY(
                                                        y: 80,
                                                        context: context),
                                                  ),
                                                ),
                                              );
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                  Container(
                                    width: 80,
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
            }));
  }

  // Future<Recognition> doFaceDetection(File file) async {
  //   InputImage inputImage = InputImage.fromFile(file);

  //   image = await decodeImageFromList(file.readAsBytesSync());
  //   faces = await faceDetector.processImage(inputImage);

  //   final Rect boundingBox = faces[0].boundingBox;

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
  //   img.Image? croppedFace = img.copyCrop(faceImg!,
  //       x: left.toInt(),
  //       y: top.toInt(),
  //       width: width.toInt(),
  //       height: height.toInt());

  //   Recognition recog =
  //       recognizer.recognize2(croppedFace, boundingBox, dataDummyMatrik);

  //   return recog;
  // }

  // Future<List<double>> getRecog(File file) async {
  //   InputImage inputImage = InputImage.fromFile(file);

  //   image = await decodeImageFromList(file.readAsBytesSync());
  //   faces = await faceDetector.processImage(inputImage);

  //   final Rect boundingBox = faces[0].boundingBox;

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
  //   img.Image? croppedFace = img.copyCrop(faceImg!,
  //       x: left.toInt(),
  //       y: top.toInt(),
  //       width: width.toInt(),
  //       height: height.toInt());

  //   List<double> recog = recognizer1.recog(
  //     croppedFace,
  //     boundingBox,
  //   );

  //   return recog;
  // }
}
