import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menzy/Controllers/video-controller.dart';
import 'package:menzy/View/Home/home.dart';
import 'package:menzy/main.dart';
import 'package:menzy/utils/App-Colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../../Controllers/auth-controller.dart';
import '../../Utils/App-TextStyle.dart';
import '../../Widget/app_button.dart';
import '../metaverse/metaverse.dart';

class CameraScreen extends StatefulWidget {
  final bool? fromunity;
  final UnityWidgetController? unityWidgetController;
  CameraScreen({Key? key, this.fromunity, this.unityWidgetController})
      : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  VideoPlayerController? videoController;

  File? _imageFile;
  File? _videoFile;

  // Initial values
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  bool _isRearCameraSelected = true;
  bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  // Current values
  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;

  List<File> allFileList = [];

  final resolutionPresets = ResolutionPreset.values;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras[0]);
      refreshAlreadyCapturedImages();
    } else {
      log('Camera Permission: DENIED');
    }
  }

  refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    List<Map<int, dynamic>> fileNames = [];

    fileList.forEach((file) {
      if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
        allFileList.add(File(file.path));

        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    });

    if (fileNames.isNotEmpty) {
      final recentFile =
          fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      if (recentFileName.contains('.mp4')) {
        _videoFile = File('${directory.path}/$recentFileName');
        _imageFile = null;
        _startVideoPlayer();
      } else {
        _imageFile = File('${directory.path}/$recentFileName');
        _videoFile = null;
      }

      setState(() {});
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (_videoFile != null) {
      videoController = VideoPlayerController.file(_videoFile!);
      await videoController!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
      await videoController!.setLooping(true);
      await videoController!.play();
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (controller!.value.isRecordingVideo) {
      // A recording has already started, do nothing.
      return;
    }

    try {
      await cameraController!.startVideoRecording();
      startTimer();
      setState(() {
        _isRecordingInProgress = true;
        print(_isRecordingInProgress);
      });
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  File? videoFile;
  bool isLoading = false;
  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Recording is already is stopped state
      return null;
    }

    try {
      XFile file = await controller!.stopVideoRecording();

      setState(() {
        _isRecordingInProgress = false;
      });
      return file;
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // Video recording is not in progress
      return;
    }

    try {
      await controller!.pauseVideoRecording();
    } on CameraException catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      // No video recording was in progress
      return;
    }

    try {
      await controller!.resumeVideoRecording();
    } on CameraException catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  Timer? _timer;
  int _start = 30;
  Timer? countDownTimer;
  int _countStart = 3;
  @override
  void initState() {
    // Hide the status bar in Android
    SystemChrome.setEnabledSystemUIOverlays([]);
    getPermissionStatus();
    super.initState();
  }

  void startCountDownTimer() {
    const oneSec = const Duration(seconds: 1);
    setState(() {
      _countStart = 3;
    });
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countStart == 0) {
          setState(() {
            timer.cancel();
          });
          startVideoRecording();
        } else {
          setState(() {
            _countStart--;
          });
        }
      },
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    setState(() {
      _start = 30;
    });
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isRecordingInProgress = false;
          });
          uploadVideo();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void uploadVideo() async {
    XFile? rawVideo = await stopVideoRecording();
    File videoFile = File(rawVideo!.path);
    await VideoCompress.setLogLevel(0);

    setState(() {
      isLoading = true;
    });
    // if (videoDuration == 30) {
    final info = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    print(info?.path);
    setState(() {
      videoFile = File(info?.path ?? "");
    });
    if (videoFile != null) {
      await VideoController()
          .uploadVideo(
              userId:  Get.find<AuthController>().user.value.id,
              context: context,
              videoFile: videoFile,
              fromunity: widget.fromunity)
          .then((value) => widget.unityWidgetController?.postMessage(
              'GameManager', 'OnChallengeCompleted', "ChallengeCompleted"));
    }
    setState(() {
      isLoading = false;
      _start = 30;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (widget.fromunity == true) {
            Get.offAll(() => MetaverseScreen());
            widget.unityWidgetController?.postMessage(
                'GameManager', 'OnChallengeFailed', "ChallengeFailed");
          }
          return widget.fromunity == true ? false : true;
        },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Column(children: [
              SizedBox(
                height: 50,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              "back",
                              style: AppTextStyle.boldWhite14,
                            )
                          ],
                        ))),
              ),
              _isCameraPermissionGranted
                  ? _isCameraInitialized
                      ? Expanded(
                          child: Stack(
                            children: [
                              CameraPreview(
                                controller!,
                                child: LayoutBuilder(builder:
                                    (BuildContext context,
                                        BoxConstraints constraints) {
                                  return GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTapDown: (details) =>
                                        onViewFinderTap(details, constraints),
                                  );
                                }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, left: 8, top: 8),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.5)),
                                                  ),
                                                  Container(
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.5)),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.5)),
                                                  ),
                                                  Container(
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 0.5)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          isLoading
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(top: 60),
                                                  width: 200,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    children: [
                                                      const LinearProgressIndicator(
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                255, 159, 231),
                                                        color:
                                                            AppColors.primary,
                                                        minHeight: 5,
                                                      ),
                                                      SizedBox(
                                                        height: 12,
                                                      ),
                                                      Text(
                                                        "Video Uploading...",
                                                        style: AppTextStyle
                                                            .mediumWhite14,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.5)),
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.5)),
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 0.5)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '\"Move at least 5 feet away from your mobile screen for better result"',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      height: 1.4),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'This is Test Mode',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'To receive rewards upload for result',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 50,
                                          ),
                                          _isVideoCameraSelected
                                              ? _countStart != 0
                                                  ? Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                            _countStart
                                                                .toString(),
                                                            style: AppTextStyle
                                                                .boldWhite16),
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          height: 10,
                                                          width: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          (_start >= 10)
                                                              ? "00:$_start"
                                                              : "00:0$_start",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                              : Container(),
                                          InkWell(
                                            onTap:
                                                // _isRecordingInProgress
                                                //     ? () async {
                                                //         if (controller!.value.isRecordingPaused) {

                                                //           await resumeVideoRecording();

                                                //         } else {
                                                //           await pauseVideoRecording();
                                                //         }
                                                //       }
                                                //     :
                                                _isRecordingInProgress
                                                    ? () {}
                                                    : () {
                                                        setState(() {
                                                          _isCameraInitialized =
                                                              false;
                                                        });
                                                        onNewCameraSelected(cameras[
                                                            _isRearCameraSelected
                                                                ? 1
                                                                : 0]);
                                                        setState(() {
                                                          _isRearCameraSelected =
                                                              !_isRearCameraSelected;
                                                        });
                                                      },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.black38,
                                                  size: 60,
                                                ),
                                                // _isRecordingInProgress
                                                //     ? controller!.value.isRecordingPaused
                                                //         ? Icon(
                                                //             Icons.play_arrow,
                                                //             color: Colors.white,
                                                //             size: 30,
                                                //           )
                                                //         : Icon(
                                                //             Icons.pause,
                                                //             color: Colors.white,
                                                //             size: 30,
                                                //           )
                                                //     :
                                                Icon(
                                                  _isRearCameraSelected
                                                      ? Icons.camera_rear
                                                      : Icons.camera_front,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppButton(
                                      borderSideColor: AppColors.primary,
                                      onPressed: (isLoading)
                                          ? () {}
                                          : () async {
                                              if (!_isVideoCameraSelected) {
                                                setState(() {
                                                  _isVideoCameraSelected = true;
                                                });
                                              }

                                              if (_isRecordingInProgress) {
                                                if (_start != 0) {
                                                  // uploadVideo();
                                                  await stopVideoRecording();
                                                  setState(() {
                                                    _timer?.cancel();
                                                    _start = 30;
                                                  });

                                                  Get.snackbar("Warning",
                                                      "Hey! Your video is shorter than 30 seconds",
                                                      icon: Icon(
                                                        Icons.warning_rounded,
                                                        color: Colors.white,
                                                      ),
                                                      backgroundColor:
                                                          AppColors.red,
                                                      colorText:
                                                          AppColors.white);
                                                }
                                              } else {
                                                startCountDownTimer();
                                                // await startVideoRecording();
                                              }
                                            },
                                      overlayColor: AppColors.lightBlue,
                                      textColor: AppColors.white,
                                      textStyle: AppTextStyle.boldWhite16,
                                      text: !_isRecordingInProgress
                                          ? 'Start Video'
                                          : 'Stop',
                                      height: 50,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 22.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/logo.png",
                                      height: 35,
                                    ),
                                    Text(
                                      "  Menzy Move",
                                      style: AppTextStyle.regularWhite16,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text(
                            'LOADING',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(),
                        Text(
                          'Permission denied',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: AppColors.primary),
                          onPressed: () {
                            getPermissionStatus();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Give permissions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ])),
      ),
    );
  }
}
