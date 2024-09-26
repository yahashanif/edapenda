import 'package:camera/camera.dart';
import 'package:dapenda/app/constant.dart';
import 'package:dapenda/app/routes.dart';
import 'package:dapenda/cubit/image_cubit/current_image_cubit.dart';
import 'package:dapenda/repository/ml_service.dart';
import 'package:dapenda/widgets/box_gap.dart';
import 'package:dapenda/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liveness_detection_flutter_plugin/index.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'
    // ignore: library_prefixes
    as faceD;

import 'package:path/path.dart' as path;

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../main.dart';
import '../../model/Recognition.dart';
import '../../repository/Recognizer.dart';

class RecognationScreen extends StatefulWidget {
  final List<double> dataAPI;

  const RecognationScreen({super.key, required this.dataAPI});

  @override
  State<RecognationScreen> createState() => _RecognationScreenState();
}

class _RecognationScreenState extends State<RecognationScreen>
    with TickerProviderStateMixin {
  AnimationController? controller;
  CameraImage? cameraImage;
  // CameraController cameraController = CameraController(
  //   CameraDescription(
  //     name: "default",
  //     lensDirection: CameraLensDirection.front,
  //     sensorOrientation: 90,
  //   ),
  //   ResolutionPreset.high,
  // );
  Animation<double>? animation;
  File? _image;
  String? imgPath;
  var image;
  List<faceD.Face> faces = [];

  late faceD.FaceDetector faceDetector;
  // late Recognizer recognizer;
  late Recognition recognition1;
  late Recognition recognition2;
  Interpreter? _interpreter;

  List<LivenessDetectionStepItem> stepLiveness = [
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.smile,
      title: "senyum",
      isCompleted: false,
    ),
    LivenessDetectionStepItem(
      step: LivenessDetectionStep.blink,
      title: "kedip",
      isCompleted: false,
    ),
  ];
  _initializeInterpreter() async {
    _interpreter = await MLService().initialize();
  }

  Future<bool> liveness() async {
    // final String? response =
    await LivenessDetectionFlutterPlugin.instance
        .livenessDetection(
      context,
      config: LivenessConfig(
        steps: stepLiveness,
        startWithInfoScreen: false,
      ),
    )
        .then((value) async {
      _cameraImageToInputImage(value!);

      MLService().searchResult2(widget.dataAPI).then((dataFoto) {
        if (dataFoto) {
          Future.delayed(const Duration(seconds: 2)).then((value) {
            dataDummyMatrik.clear();
            Navigator.pushReplacementNamed(context, cameraRoute,
                arguments: value);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Wajah Tidak Sesuai\n Coba lagi"),
          ));
          Navigator.pop(context);
        }
      });
      // dataDummyMatrik.clear();
      // print("value");
      // print(value);
      // if (value != null) {
      //   setState(() {
      //     cameraImage = value;
      //     // _image = File(imgPath!);
      //   });
      //   List<double> dataFace = await doFaceDetection();
      //   print(dataFace);
      //   dataDummyMatrik.add(dataFace);
      //   print("dataDummyMatrik");
      //   print(dataDummyMatrik);
      //   print(widget.dataAPI);

      // MLService().searchResult(widget.dataAPI).then((value) {
      // if (value) {
      //   Future.delayed(const Duration(seconds: 2)).then((value) {
      //     dataDummyMatrik.clear();
      //     Navigator.pushReplacementNamed(context, cameraRoute,
      //         arguments: dataFace);
      //   });
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text("Wajah Tidak Sesuai\n Coba lagi"),
      //   ));
      // }
      // });
      // } else {
      //   Navigator.pop(context);
      // }
    });

    // print(response);

    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeInterpreter();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animation = Tween<double>(
      begin: 0.0,
      end: 2 * 3.141592653589793, // 2π radians (full circle)
    ).animate(controller!);

    controller!.repeat();
    final options = faceD.FaceDetectorOptions(
        performanceMode: faceD.FaceDetectorMode.accurate);
    faceDetector = faceD.FaceDetector(options: options);
    // recognizer = Recognizer();

    Future(() {
      liveness().then((value) async {
        print("VALUE WAWAWAWA");
        print(value);
        if (value == false) {
          Navigator.pop(context);
          // cameraController.dispose();
          // cameraController.stopImageStream();
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    // cameraController.dispose();
    // cameraController.stopImageStream();
    super.dispose();
  }

  String _buildLoadingText(int count) {
    // Membangun teks loading dengan titik-titik berdasarkan nilai count
    String dots = '.' * count;
    return 'Loading$dots';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // cameraController.dispose();
        // cameraController.stopImageStream();
        return true;
      },
      child: Scaffold(
          body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.80),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: CircularProgressIndicator(
                    color: Colors.green,
                  )),
                  AnimatedBuilder(
                    animation: animation!,
                    builder: (context, child) {
                      return Container(
                        // width: MediaQuery.of(context).size.width / 3,
                        // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        // decoration: BoxDecoration(
                        //     color: Colors.green.withOpacity(0.65),
                        //     borderRadius: BorderRadius.circular(8)),
                        child:
                            // Image.file(_image!)

                            Text(
                          _buildLoadingText((animation!.value / 2).toInt()),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<List<double>> doFaceDetection() async {
    //TODO remove rotation of camera images

    InputImage inputImage = InputImage.fromFile(_image!);

    // image = await _image?.readAsBytes();
    image = await decodeImageFromList(_image!.readAsBytesSync());
    //TODO passing input to face detector and getting detected faces
    faces = await faceDetector.processImage(inputImage);

    // for (Face face in faces) {
    final Rect boundingBox = faces[0].boundingBox;

    print("Rect " + boundingBox.toString());

    double x = boundingBox.left - 10.0;
    double y = boundingBox.top - 10.0;
    double w = boundingBox.width + 10.0;
    double h = boundingBox.height + 10.0;

    final bytes = _image!.readAsBytesSync();
    img.Image? faceImg = img.decodeImage(bytes);
    img.Image? croppedFace =
        img.copyCrop(faceImg!, x.toInt(), y.toInt(), w.toInt(), h.toInt());

    img.Image imgData = img.copyResizeCropSquare(croppedFace, 112);

    List<double> recog = await MLService()
        .setCurrentPredictionFile(imgData!, interpreter: _interpreter!);

    // _image = await writeImageToFile(
    //     Uint8List.fromList(img.encodeBmp(imgData)), "test");

    return recog;
    // showFaceRegistrationDialogue(
    //     Uint8List.fromList(img.encodeBmp(croppedFace)), recognition);
    // }

    // drawRectangleAroundFaces();

    //TODO call the method to perform face recognition on detected faces
  }

//   Future<File> writeImageToFile(Uint8List imageData, String fileName) async {
//     // Mendapatkan direktori sementara (temporary directory)
//     final directory = await getTemporaryDirectory();

//     // Membuat path lengkap untuk file baru
//     final filePath = path.join(directory.path, fileName);

//     // Membuat file baru dan menulis imageData ke dalamnya
//     final file = File(filePath);
//     await file.writeAsBytes(imageData);

//     return file;
//   }

  Future<void> _cameraImageToInputImage(CameraImage cameraImage) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());
    final imageRotation = InputImageRotationValue.fromRawValue(
      cameras[1].sensorOrientation,
    );
    final inputImageFormat = InputImageFormatValue.fromRawValue(
      cameraImage.format.raw,
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

        // dataDummyMatrik.add(result);
        // context.read<ValuePendataanFotoCubit>().setValue(result);
      });
      setState(() {});
    });
    // img.Image dataImage = MLService().convertCameraImage(cameraImage);

    // var dataFile = await saveImageToFile(dataImage, DateTime.now().toString());
    // ignore: use_build_context_synchronously
    context.read<CurrentImageCubit>().setXFile(null);
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
}
