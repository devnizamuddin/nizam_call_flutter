import 'package:permission_handler/permission_handler.dart';

Future handlePermissionForVideoCall() async {
  await [Permission.microphone, Permission.camera].request();
}
