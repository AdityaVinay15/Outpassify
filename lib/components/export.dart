// import 'dart:io';

// // import 'package:device_info_plus/device_info_plus.dart';
// import 'package:excel/excel.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'package:permission_handler/permission_handler.dart';

// Future<bool> _request_per(Permission permission) async {
//     var re = await Permission.manageExternalStorage.request();
//     if (re.isGranted) {
//       return true;
//     } else {
//       return false;
//     }
// }

// exportExcel() async {
//   if (await _request_per(Permission.storage) == true) {
//     print(
//         "sssssaaaaaafffffffffffffffffffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
//   } else {
//     print(
//         "nnnnnnnnnnnnnnnnnnooooooottttttttssssssaaaaaffffffffffffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
//   }
//   var status = await Permission.storage.request();
//   print(
//       "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^6");
//   if (status.isGranted) {
//     print('Storage permission granted');
//   } else if (status.isDenied) {
//     print('Storage permission denied');
//   } else if (status.isPermanentlyDenied) {
//     print('Storage permission permanently denied');
//     // You can open the app settings to allow the user to manually grant the permission
//     openAppSettings();
//   }
//   var excel = Excel.createExcel();
//   excel.rename(excel.getDefaultSheet()!, "Test_Sheet");
//   Sheet sheet = excel["Test_Sheet"];
//   var cell =
//       sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
//   cell.value = TextCellValue('Some Text');
//   print(
//       "Completed all the things aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaavvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
//   excel.save(fileName: 'Test_Sheet.xlsx');
//   var fileBytes = excel.save();
//   var directory = await getApplicationDocumentsDirectory();
//   print(
//       "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXAAAAAAAAAAAAAAA");
//   print(directory.path);
//   File(join('/storage/emulated/0/Test_Sheet.xlsx'))
//     ..createSync(recursive: true)
//     ..writeAsBytesSync(fileBytes!);
//   print(
//       "Completed all the things aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaavvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
// }

import 'package:gsheets/gsheets.dart';
import 'package:outpassify/components/sheetscolumn.dart';

class SheetsFlutter {
  static String _sheetId = "1QaJ8Zb3qFiEvrPGegTYJpVE-7GaoaMIR8uy0S6y7H04";
  static const _sheetCredentials = r'''
{
  "type": "service_account",
  "project_id": "outpassify-434414",
  "private_key_id": "1a2016215520a393425489cc3267c47f9e8ef0bf",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCqhe/rGfaHhcGN\nfemScYOlSQle9F9ne2H0u99wb0XMopiv9lPuRNaWFQtxxjNdzIbpu8Q+cOFgzK33\nvF14D9i/4RPu8vF8kMQEEGFJW1ARQKm18XcfJcqrHZMlel6Snxe3uWuRiCchpPe7\nWXDVGesZv8hsoijjjXVZK7PzV57sF9kKMxJPlvgxxoeCGUxTArShOgLKhMBtoScE\nScmnosAQPv9TOGHVJNhhJjLuimEBTNkLnsF67jolDidmkODp9XoO/Wt6W2mYgYjd\nQTlpukJusB/9meZAFQtAp047HtWgm7WFv66bpwNTQGwvPit3zAHlPFjIriMZc9/8\ncDAYATmlAgMBAAECggEAUU8rLsXC/S0EtSR4RslUte/lBX9trGizNSCOMs0EEcbo\nGmNQ8vik/4xKWDZjUNMQ84uCUCm/9cmzHEEXqoOX3SqEODhkeHqI1M1ArltZithz\n89sO6224PS6Ndt3qEWzFwOeriInM6uh/7bgAqsRAi5cciNwrthFCBsJlfF9n2nff\nVfIIuHLjTHmqh7wUxuYzIOva/hA5qbI0i1EQOGfry+cyey+qjoRHuuy9Wfd40xl4\nrtYurVbw1fHZsXWUwndpher/+qeOnN6vmj2nxioI/DZ+CL33aE7DlzXnPHXkEpV7\nQRsq0diWvi8QQ+IaGIVsoew5ydmnpRDqYPOdXv7+kwKBgQDSmqABhIOK4+6XJrSh\nlvmx1EQb0588pP4zH6Ver6XR9FKWlFoXQUeEjiXx2RY8xY3bUitOGtZSgKZtGwEm\n76o3vvEEFOUDWkDuHyXUiGNTQOQ7XAMWNmdNPk0mA2mgRXbguM/0fiAgPhA8RpZG\ny9MqdRhVNvGzeb3/lCcUd0gcCwKBgQDPR5srnD+v4OiwCpjw2eM0Ox/Wo2BAZE3y\n/efpmljBCZPGfTUKNvFLMjwZfl8q09SewCH87vBIPI9p0kIf7asivuZsAucVhL02\nCptrqjAIYUSOm5nEzuk41o6dqDJyAsIu1NJuvD8AF8yL8qWwkqmLaHtxVtCMOZIK\nYor+nU7fDwKBgECH0nlEkk3Pc37rBDPzH8VGZiwklsktQRqHGtO9fFCtzVSIVmaD\nwRczuxq0yuSKH+JQ9iXzgTI8a0JJIPw+OWjlX9JBWL7DO9v6vUu3EsAixQwPMH7w\n4ow/h8IbD5VlU3yeBFJFBzD5812Uv10n/ScoQ/FwaXT126rhSWwy9GxrAoGAHmtx\n2Fqb9iHZxEwp2d8AOyAaMhPUAl82GV0t9diTAfF34H9rk04w50o+C7fCG7Tu1UV5\nN3eRh+hrW6phzfHBVd4STvO2GjBa3F1+JbTaS8CKoSswy/NZwt+qGnUewiCpgtn0\n8A9sZ4UWnctEib9cZns08pM9E/c2+ZMwtuE7O/0CgYBt8aSUUAzuI64DTxD4WQMb\n1Aqr/qgZms44ELBZfgU9mz9VotiPPF04qbe9d+13GDKXTSLTMFkhiTkVMtvpzfmC\n2dpKaaHyKC3SJwzplh3h3twwjlO/hCDneERBD97qJFDyh0/s9Lu7k1BoKWBQW+DE\nBG7t2G8MNrT5pSkKJFnLyA==\n-----END PRIVATE KEY-----\n",
  "client_email": "fluttersheets@outpassify-434414.iam.gserviceaccount.com",
  "client_id": "116150883819517314224",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/fluttersheets%40outpassify-434414.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';
  static Worksheet? _userSheet;
  static final _gsheets = GSheets(_sheetCredentials);
  static Future init() async {
    print(
        "WORKSHETTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW");
    try {
      final spreadsheet = await _gsheets.spreadsheet(_sheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: "Feed");
      final firstRow = SheetsColumn.getColumns();
      _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print(e);
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    print(
        "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddaaaaaaaaaaaaa");
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return await spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    print(
        "Futureeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiinnnnnnnnnnnnnnnnfff");
    print(_userSheet);
    _userSheet!.values.map.appendRows(rowList);
  }
}
