import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/androidenterprise/v1.dart';
import 'package:permission_handler/permission_handler.dart' as permHandler;

getPermission() async => await [
      permHandler.Permission.sms,
    ].request();
Future<bool> isPermissionGranted() async =>
    await permHandler.Permission.sms.status.isGranted;
sendSms(String phoneNumber, String message, {int? simSlot}) async {
  var result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber, message: message, simSlot: simSlot);
  print(
      "Sendingsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
  if (result == SmsStatus.sent) {
    print("Sms sent sussesfullyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
  } else {
    print("Sms not sentttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
  }
}
