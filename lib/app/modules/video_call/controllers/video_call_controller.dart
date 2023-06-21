import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_config.dart';
import '../../../utils/handle_permission.dart';

class VideoCallController extends GetxController {
  RxBool isJoined = false.obs;
  RxInt remoteUid = 0.obs;
  RxInt uid = 0.obs;

  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await handlePermissionForVideoCall();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine
        .initialize(const RtcEngineContext(appId: AppConfig.AGORA_APP_ID));

    await agoraEngine.enableVideo();

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              'Local user uid:${connection.localUid} joined the channel');
          isJoined.value = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage('Remote user uid:$remoteUid joined the channel');

          this.remoteUid.value = remoteUid;
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage('Remote user uid:$remoteUid left the channel');
          this.remoteUid.value = -1;
        },
      ),
    );
  }

  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: AppConfig.AGORA_TOKEN,
      channelId: AppConfig.AGORA_CHANNEL_ID,
      options: options,
      uid: uid.value,
    );
  }

  void leave() {
    isJoined.value = false;
    remoteUid.value = 0;
    agoraEngine.leaveChannel();
  }

  @override
  void onInit() {
    setupVideoSDKEngine();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
