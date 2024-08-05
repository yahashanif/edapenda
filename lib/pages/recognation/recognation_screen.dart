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

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../model/Recognition.dart';
import '../../repository/Recognizer.dart';

class RecognationScreen extends StatefulWidget {
  const RecognationScreen({super.key});

  @override
  State<RecognationScreen> createState() => _RecognationScreenState();
}

class _RecognationScreenState extends State<RecognationScreen>
    with TickerProviderStateMixin {
  AnimationController? controller;
  CameraController cameraController = CameraController(
    CameraDescription(
      name: "default",
      lensDirection: CameraLensDirection.front,
      sensorOrientation: 90,
    ),
    ResolutionPreset.high,
  );
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
      print("value");
      print(value);
      if (value != null) {
        setState(() {
          imgPath = value;
          _image = File(imgPath!);
        });
        List<double> dataFace = await doFaceDetection();
        print(dataFace);

        Future.delayed(Duration(seconds: 2)).then((value) {
          Navigator.pushReplacementNamed(context, cameraRoute,
              arguments: dataFace);
        });
      } else {
        Navigator.pop(context);
      }
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
        if (value == false) {
          Navigator.pop(context);
          cameraController.dispose();
          cameraController.stopImageStream();
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    cameraController.dispose();
    cameraController.stopImageStream();
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
        cameraController.dispose();
        cameraController.stopImageStream();
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
                        child: Text(
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

    num left = boundingBox.left < 0 ? 0 : boundingBox.left;
    num top = boundingBox.top < 0 ? 0 : boundingBox.top;
    num right =
        boundingBox.right > image.width ? image.width - 1 : boundingBox.right;
    num bottom = boundingBox.bottom > image.height
        ? image.height - 1
        : boundingBox.bottom;
    num width = right - left;
    num height = bottom - top;

    final bytes = _image!.readAsBytesSync();
    img.Image? faceImg = img.decodeImage(bytes);
    img.Image? croppedFace = img.copyCrop(
        faceImg!, left.toInt(), top.toInt(), width.toInt(), height.toInt());

    List<double> recog = await MLService()
        .setCurrentPredictionFile(croppedFace, interpreter: _interpreter!);

    return recog;
    // showFaceRegistrationDialogue(
    //     Uint8List.fromList(img.encodeBmp(croppedFace)), recognition);
    // }

    // drawRectangleAroundFaces();

    //TODO call the method to perform face recognition on detected faces
  }
}
