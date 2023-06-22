import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../config/app_config.dart';
import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(alignment: AlignmentDirectional.topEnd, children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            // Container for the local video
            Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Obx(
                  () => Center(child: _remoteVideo()),
                )),
            // Button Row
            Obx(
              () => Container(
                padding: const EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: controller.isJoined.value,
                      child: InkWell(
                        onTap: controller.leave,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          width: 150,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(
                                Icons.call,
                                size: 24,
                                color: Colors.white,
                              ),
                              Text(
                                'End call',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !controller.isJoined.value,
                      child: InkWell(
                        onTap: controller.join,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          width: 150,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Icon(
                                Icons.call,
                                size: 24,
                                color: Colors.white,
                              ),
                              Text(
                                'Start call',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    letterSpacing: 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            // Button Row ends
          ],
        ),
        //Container for the Remote video
        Positioned(
          right: 24,
          top: 24,
          child: Container(
              height: 128,
              width: 128,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Obx(
                () => Center(child: _localPreview()),
              )),
        ),
      ]),
    ));
  }

  // Display local video preview
  Widget _localPreview() {
    if (controller.isJoined.value) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: controller.agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return Container();
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (controller.remoteUid.value != 0) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.agoraEngine,
          canvas: VideoCanvas(uid: controller.remoteUid.value),
          connection:
              const RtcConnection(channelId: AppConfig.AGORA_CHANNEL_ID),
        ),
      );
    } else {
      String msg = '';
      if (controller.isJoined.value) msg = 'Waiting for other user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
