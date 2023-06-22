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
                  () => Center(child: _localPreview()),
                )),
            // Button Row
            Obx(
              () => Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RawMaterialButton(
                      onPressed: controller.isJoined.value
                          ? () => {controller.leave()}
                          : null,
                      elevation: 2.0,
                      fillColor: Colors.red,
                      child: Icon(
                        Icons.call_end,
                        size: 35.0,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                    ),
                    const SizedBox(width: 40),
                    RawMaterialButton(
                      onPressed: controller.isJoined.value
                          ? null
                          : () => {controller.join()},
                      elevation: 2.0,
                      fillColor: Colors.green,
                      child: Icon(
                        Icons.call,
                        size: 35.0,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
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
                () => Center(child: _remoteVideo()),
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
      return const Text(
        'Start',
        textAlign: TextAlign.center,
      );
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
      if (controller.isJoined.value) msg = 'Waiting';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
