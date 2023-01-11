import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:menzy/Controllers/get-videos-controller.dart';
import 'package:menzy/utils/App-Contants.dart';
import 'package:video_box/video_box.dart';

import '../../utils/App-TextStyle.dart';

class ViewVideo extends StatefulWidget {
  ViewVideo();

  @override
  _ViewVideoState createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  List<VideoController> vcs = [];
  final getVideoController = Get.put(GetVideoController());

  getMenzyVideos() async {
    await getVideoController.getVideo(context: context);
    for (var i = 0; i < getVideoController.menzyVideos.length; i++) {
      vcs.add(VideoController(
          source: VideoPlayerController.file(File(AppConstants.SERVER_URL +
              "/" +
              getVideoController.menzyVideos[i].filename.toString())))
        ..initialize());
    }
    print(
        "${AppConstants.SERVER_URL + "/" + getVideoController.menzyVideos[0].filename.toString()}");
  }

  @override
  void initState() {
    super.initState();
    getMenzyVideos();
  }

  @override
  void dispose() {
    for (var vc in vcs) {
      vc.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'View videos',
            style: AppTextStyle.mediumWhite14,
          ),
        ),
        body: ListView(
          children: <Widget>[
            for (var vc in vcs)
              Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: AspectRatio(
                      aspectRatio: 10 / 10, child: VideoBox(controller: vc))),
          ],
        ));
  }
}
