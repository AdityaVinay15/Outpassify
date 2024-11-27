import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "outpassify-78b92",
      "private_key_id": "bee0fb48517ec7295b3b5a094f55e58aee26b273",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDvKjJ4h6Gu8UWK\nEFMOeLXUdaOr5rgyVEAYjh4VyGCUnjOHxQhvAuaI8aK5iHbMYjG/Qgl4MAaIQ5n1\nj8Smxhz3vCk83fFyAueYIx9ziaS51oRdRO4/pCzDe9xOxlx5MdMr0lolLP+nFWyj\n4AjEcMA7C/xIzMJRzNrW8zgHCC8jD4ooeqM2c+LrEYXwmyIOc4Y5uDFY5MQ9yr/3\nvuKJe6nL2Y0fbO+yJb/iPq1VSAr54I0wAtKL0jgH7Ph5bWknbAdxwDpzIlQVUyGY\n1Rt7KFRDUTcbTmN5PUAHo6k/OQXNMRzwZJhfz5iu8fFSKJ+Yvz4AmFUqWlRAhAFj\nCRdUCEFbAgMBAAECggEABRKSC3hk937qiKkb+dyZjq4IEKdOFNMwoNSy0qdzVPOe\nCC0npqMbHKBzYRgB3QfgIjxWUxRBrzYv18N62katapu1DDNw4YgqPVHRYvPyaHai\nTBAgNX1X7bV80LboUzG5Vt6ZRtyTd4m+yiMATJpPmXEBotGk9XMw2QpDj/KefVHW\njz43TjqSZGr82xIC76jHNBcQzC+t0VRVVvQCUh2CmjUOmahnIknherFuE86g9Yjb\nLhSl4ID+l5hp6qlENiufnykdYoYqzYJFakJcEKWpWlH8NoUncl4DlxuONkI/QRUr\nQubIqf7O2ELBtcYMffYNtjtG8G1SFl05IYjT6iqXAQKBgQD4w8DJ+siLLcfYn6TZ\niipod9sWyKQVFMnpFrQsn4ncghcj1PVVQ15hT9lu934vcMg/IW34r/pUMDhmF6Sm\nshT2qRRd6PMb+Fk8xyMyNGO9QlisqjpoCeD7IGX3gEjSA72KkrbNjejhrMLTgozy\nRJmMBSj7CbOJo5N4H7Q+0TXpQQKBgQD2HvdC3cOKBTq1aL6pc8M/fDJlebIiRDum\nwdo5BZoA6JQ4K1dpUMGExioqncAjs30ZlFKOgRHi/00oGb0uHnDjVT5cylvptx10\nAf1cwF9LfxEfKP+6scMLmmoFZPo8wCo1KV2SsBxWrG7YduGdHqL+LVkJJWRlAf5C\nCGddTPNHmwKBgBF9shCBkZg3n9WbY/vnuxOdWcpAUUkqLQg2kHSSwx6+BuJ+FsHn\n+rrc4mzq+fRb+bh2oUTbGr7QpSaIgws1ekPdn5D60B0nWR7s4YymIl0sTQ/W6ERo\nbWk63fCJFJWvraQQrMnHMJitjQVSKJbgO+uccUU1aWpEFhpcIFBKZYABAoGALuTx\nic0FP9wFNqFxionjDsqUM59/YGYN05UmBi1aDYhDDXy8l/VqGelECYCrJmJBmMkY\n/cv743tvcQ+OayYjrj0Et9tarepU81CZvL1uqszYL065gxHxrtlKECMQRtj6ccyi\n5pslmyIZsKbeD/jRZ4quZz63pUM+9cfyIeXSiLcCgYEAvDzdvTw/AVEAFpM1NK00\nzYMjmKKY5kt0I2vYCaqrfLr1rt6LodS87boAjcyGNuuAKQn5sJTRL8QgK1cspfZm\nfgKvca4IMaO73iYLIqScCVNacqsGyC+TE70ZFh0L7zT+xOYWtkkl6YJWceOBCqK0\n7m5fHnz4Jph01VWkp5McOlc=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "outpassify-pragati@outpassify-78b92.iam.gserviceaccount.com",
      "client_id": "101034034374701684388",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/outpassify-pragati%40outpassify-78b92.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static sendNotification(
      String deviceToken, BuildContext context, String rollnumber,String purpose) async {
    final String serverAccessTokenKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/outpassify-78b92/messages:send';
    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title':rollnumber,
          'body': purpose
        },
        'data': {
          'rollnumber': rollnumber,
        }
      }
    };
    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      print(
          "Notfication Sent Successfullyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
    } else {
      print(
          "Notfication Sent not Successfullxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvccccccccccccccccc");
    }
  }
}
