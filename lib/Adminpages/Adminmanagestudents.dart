import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outpassify/components/newuser.dart';
import 'package:outpassify/routes/app_route_constants.dart';
import 'package:csv/csv.dart';

class Adminmanagestudents extends StatefulWidget {
  const Adminmanagestudents({super.key});

  @override
  State<Adminmanagestudents> createState() => _Adminmanagestudents();
}

class _Adminmanagestudents extends State<Adminmanagestudents> {
  int indexs = 0;
  List<String> _columnNames = [
    'Studentname',
    'Rollnumber',
    'Email',
    'Year',
    'Branch',
    'Section',
    'Contactnumber',
    'Parentcontactnumber'
  ];
  List<String> columnname2 = ['Rollnumber'];

  @override
  void initState() {
    super.initState();
    _checkForNotifications();
  }

  bool hasNotifications = false;
  Future<void> _checkForNotifications() async {
    try {
      // Replace 'your_rollnumber' with the actual roll number or other criteria
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Requests')
          .where('Approvalstatus', isEqualTo: 0)
          .get();

      setState(() {
        hasNotifications = querySnapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  List<Widget> widgets = [
    Text("Home"),
    Text("Inbox"),
    Text("Adminmanagestudents"),
    Text("Profile"),
  ];
  int currentIndex = 0;

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    switch (index) {
      case 0:
        print("Homeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
        GoRouter.of(context).pushNamed(MyAppRouteConstants.adminRouteName);
        break;
      case 1:
        GoRouter.of(context)
            .pushNamed(MyAppRouteConstants.adminpermissionRouteName);
        break;
      case 2:
        GoRouter.of(context)
            .pushNamed(MyAppRouteConstants.adminsettingsRouteName);
        break;
      case 3:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.admininfoRouteName);
        break;
      default:
        GoRouter.of(context).pushNamed(MyAppRouteConstants.adminRouteName);
    }
  }

  void signUserOut() {
    print("Otttttttttttttttttttttttttt");
    FirebaseAuth.instance.signOut();
    GoRouter.of(context).pushNamed(MyAppRouteConstants.logout);
  }

  void _showCustomPopup(BuildContext context, String title, String message,
      Color backgroundColor, Color textColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info,
                color: textColor,
                size: 40,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white, // Button background color
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Increase padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: backgroundColor.computeLuminance() > 0.5
                        ? Colors.green[700]
                        : Colors.black, // Text color for contrast
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Increase font size if needed
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteRequestsByRollNumber(String rollNumber) async {
    try {
      // Reference to the Firestore collection
      CollectionReference requestsCollection =
          FirebaseFirestore.instance.collection('Requests');

      // Query to get documents matching the roll number
      QuerySnapshot querySnapshot = await requestsCollection
          .where('Rollnumber', isEqualTo: rollNumber)
          .get();

      // Delete each document found in the query
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('All requests for roll number $rollNumber have been deleted.');
    } catch (e) {
      print('Error deleting requests: $e');
    }
  }

  // ADD STUDENT MANUALLY
  void _showAddStudentDialog() {
    // Create TextEditingControllers for each field
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _rollNumberController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _yearController = TextEditingController();
    final TextEditingController _branchController = TextEditingController();
    final TextEditingController _sectionController = TextEditingController();
    final TextEditingController _contactNumberController =
        TextEditingController();
    final TextEditingController _parentcontactNumberController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Student'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Student Name'),
                ),
                TextField(
                  controller: _rollNumberController,
                  decoration: InputDecoration(labelText: 'Roll Number'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Year'),
                ),
                TextField(
                  controller: _branchController,
                  decoration: InputDecoration(labelText: 'Branch'),
                ),
                TextField(
                  controller: _sectionController,
                  decoration: InputDecoration(labelText: 'Section'),
                ),
                TextField(
                  controller: _contactNumberController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                ),
                TextField(
                  controller: _parentcontactNumberController,
                  decoration:
                      InputDecoration(labelText: 'Parent Contact Number'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                // Collect data from controllers
                String name = _nameController.text.trim();
                String rollNumber =
                    _rollNumberController.text.toUpperCase().trim();
                String email = _emailController.text.trim();
                String year = _yearController.text.trim();
                String branch = _branchController.text.trim().toUpperCase();
                String section = _sectionController.text.trim().toUpperCase();
                String contactNumber = _contactNumberController.text.trim();
                String parentcontactNumber =
                    _contactNumberController.text.trim();

                if (name.isNotEmpty &&
                    rollNumber.isNotEmpty &&
                    email.isNotEmpty &&
                    year.isNotEmpty &&
                    branch.isNotEmpty &&
                    section.isNotEmpty &&
                    contactNumber.isNotEmpty) {
                  try {
                    // Add data to Firestore
                    await FirebaseFirestore.instance
                        .collection('Students')
                        .doc(email)
                        .set({
                      'Name': name,
                      'Rollnumber': rollNumber,
                      'Email': email,
                      'Year': int.tryParse(year),
                      'Branch': branch,
                      'Section': section,
                      'Contactnumber': int.tryParse(contactNumber),
                      'Parentcontactnumber': int.tryParse(parentcontactNumber),
                      'Profilepicture': "",
                      'Devicetoken': null,
                      'Status': 0,
                    });
                    print(
                        "Mail TOPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
                    sendEmail(
                        email,
                        'none',
                        "Welcome to OutPassIfy",
                        "Dear User,\n\n"
                            "We are delighted to welcome you to OutPassIfy. Your account has been successfully created. \n"
                            "Your Account Email: ${email}\n\n"
                            "For Password , Please click on Forgot Password to generate password."
                            "Please keep this information secure.\n\n"
                            "If you have any questions or need further assistance, please do not hesitate to contact Us.\n\n"
                            "Thank you for choosing OutPassIfy.\n\n"
                            "Best regards,\n"
                            "The OutPassIfy Team\n\n"
                            "NOTE: Allow mails from Us with notification on clicking Looks Safe button.");
                    print(
                        "Mail bottommmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
                    Navigator.pop(context);
                    _showCustomPopup(
                        context,
                        'Success',
                        'Student Added Successfully!!',
                        Colors.green,
                        Colors.white);
                  } catch (e) {
                    Navigator.pop(context);
                    _showCustomPopup(
                        context, 'Error', '$e', Colors.red, Colors.white);
                  }
                  // Navigator.of(context).pop();
                } else {
                  Navigator.pop(context);
                  _showCustomPopup(context, 'Error', 'Incomplete fields.',
                      Colors.red, Colors.white);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showColumnNames(VoidCallback onProceed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Column Names'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _columnNames.map((name) => Text(name)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onProceed(); // Call the callback to proceed with the upload
              },
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  //UPLOAD EXCEL SHEET
  void _uploadFile() async {
    _showColumnNames(() async {
      // Pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // Read the file
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        // Check if the excel object contains any sheets
        if (excel.tables.isEmpty) {
          print('No sheets found in the Excel file');
          _showCustomPopup(context, 'Error',
              'No sheets found in the Excel file', Colors.red, Colors.white);
          return;
        }

        // Assuming the first sheet contains the data
        var sheet = excel.tables[excel.tables.keys.first];

        // Extract the data
        List<List<dynamic>> rows = [];
        if (sheet != null) {
          for (var row in sheet.rows) {
            rows.add(row
                .map((cell) => cell?.value?.toString().trim() ?? '')
                .toList());
          }
        }

        print('Excel Rows: $rows'); // Debugging print

        // Validate header row
        if (rows.isNotEmpty) {
          var headerRow =
              rows[0].map((e) => e.toString().trim().toUpperCase()).toList();
          print('Header Row: $headerRow'); // Debugging print

          // Define the expected column order
          List<String> expectedHeader = [
            'STUDENTNAME',
            'ROLLNUMBER',
            'EMAIL',
            'YEAR',
            'BRANCH',
            'SECTION',
            'CONTACTNUMBER',
            'PARENTCONTACTNUMBER'
          ];

          // Check if the header row matches the expected column order
          if (headerRow.length != expectedHeader.length ||
              !headerRow.asMap().entries.every((entry) =>
                  entry.value.toUpperCase() == expectedHeader[entry.key])) {
            print('Invalid column order in Excel file');
            _showCustomPopup(context, 'Error',
                'Invalid column order in Excel file', Colors.red, Colors.white);

            return; // Exit the function if the order is incorrect
          }

          // Process rows if header is valid
          for (var i = 1; i < rows.length; i++) {
            var row = rows[i];
            print('Processing Row $i: $row'); // Debugging print

            // Check if the row has at least 8 elements
            if (row.length < 8) {
              print("Skipping row $i due to insufficient data: $row");
              _showCustomPopup(
                  context,
                  'Error',
                  'Skipping row $i due to insufficient data: $row',
                  Colors.red,
                  Colors.white);

              continue;
            }

            // Access row elements safely
            String rollNumber = row[1].toString().toUpperCase().trim();
            String email = row[2].toString().trim();
            int? year = int.tryParse(row[3].toString().trim());
            int? contactNumber = int.tryParse(row[6].toString().trim());
            // Check if Parentcontactnumber exists before accessing
            int? parentContactNumber =
                row.length > 7 ? int.tryParse(row[7].toString().trim()) : null;

            Map<String, dynamic> studentData = {
              'Name': row[0].toString().trim(),
              'Rollnumber': rollNumber,
              'Email': email,
              'Year': year,
              'Branch': row[4].toString().trim().toUpperCase(),
              'Section': row[5].toString().trim().toUpperCase(),
              'Contactnumber': contactNumber,
              'Parentcontactnumber':
                  parentContactNumber ?? 0, // Default to 0 if null
              'Profilepicture': "",
              'Devicetoken': "",
              'Status': 0,
            };

            try {
              await FirebaseFirestore.instance
                  .collection('Students')
                  .doc(email)
                  .set(studentData);
              print('Data for roll number $email uploaded successfully');
              _showCustomPopup(
                  context,
                  'Success',
                  'Data for roll number $email uploaded successfully',
                  Colors.green,
                  Colors.white);
            } catch (e) {
              print('Error uploading data for roll number $email: $e');
              _showCustomPopup(
                  context,
                  'Error',
                  'Error uploading data for roll number $email: $e',
                  Colors.red,
                  Colors.white);
            }
          }
        } else {
          print('Excel file is empty');
          _showCustomPopup(context, 'Error', 'Excel file is empty', Colors.red,
              Colors.white);
        }
      } else {
        print('No file selected');
        _showCustomPopup(
            context, 'Error', 'No file selected', Colors.red, Colors.white);
      }
    });
  }

  void _deleteStudentData() async {
    final TextEditingController _rollNumberController = TextEditingController();

    // Show a dialog to enter the roll number to delete
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Student Data'),
          content: TextField(
            controller: _rollNumberController,
            decoration: InputDecoration(
              labelText: 'Enter Roll Number',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                String rollNumberToDelete =
                    _rollNumberController.text.trim().toUpperCase();

                if (rollNumberToDelete.isNotEmpty) {
                  try {
                    // Query the Firestore collection to find the document by Rollnumber
                    final querySnapshot = await FirebaseFirestore.instance
                        .collection('Students')
                        .where('Rollnumber', isEqualTo: rollNumberToDelete)
                        .get();
                    deleteRequestsByRollNumber(rollNumberToDelete);
                    if (querySnapshot.docs.isNotEmpty) {
                      // Delete all matching documents
                      for (var doc in querySnapshot.docs) {
                        final profilePictureUrl = doc['Profilepicture'];
                        if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
                          final storageRef = FirebaseStorage.instance.refFromURL(profilePictureUrl);
                          await storageRef.delete();
                        }
                        await FirebaseFirestore.instance
                            .collection('Students')
                            .doc(doc.id)
                            .delete();
                      }
                      _showCustomPopup(
                          context,
                          'Success',
                          'Student data deleted successfully',
                          Colors.green,
                          Colors.white);
                    } else {
                      _showCustomPopup(
                          context,
                          'Error',
                          'No student found with that Rollnumber',
                          Colors.red,
                          Colors.white);
                    }
                  } catch (e) {
                    _showCustomPopup(
                        context,
                        'Error',
                        'Error deleting student data: $e',
                        Colors.red,
                        Colors.white);
                  }
                }

                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showColumnNames2(VoidCallback onProceed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Column Name'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: columnname2.map((name) => Text(name)).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onProceed(); // Call the callback to proceed with the upload
              },
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

// Function to handle the file upload
  Future<void> _uploadXlsx() async {
    // Define the column names to look for
    // List<String> columnname2 = ['Rollnumber'];

    // Show the column names dialog and proceed with file picking
    _showColumnNames2(() async {
      // Pick the Excel file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        try {
          var bytes = file.readAsBytesSync();
          var excel = Excel.decodeBytes(bytes);

          // Extract roll numbers
          List<String> rollNumbers = [];
          if (excel.tables.isNotEmpty) {
            // Assuming the first sheet contains the data
            var sheet = excel.tables[excel.tables.keys.first];

            if (sheet != null) {
              // Print the header row to debug
              if (sheet.rows.isNotEmpty) {
                var headerRow = sheet.rows.first;
                // Clean and print the header row
                List<String> cleanedHeaders = headerRow
                    .map((e) => _cleanColumnName(e?.toString() ?? ''))
                    .toList();
                print(
                    'Cleaned Header Row: $cleanedHeaders'); // Debugging statement

                // Find the column index for 'Rollnumber'
                int rollNumberColumnIndex = -1;
                for (int i = 0; i < cleanedHeaders.length; i++) {
                  String headerCell = cleanedHeaders[i];
                  if (columnname2.contains(headerCell)) {
                    rollNumberColumnIndex = i;
                    break;
                  }
                }

                if (rollNumberColumnIndex == -1) {
                  _showCustomPopup(
                      context,
                      'Error',
                      'Rollnumber column not found in the Excel file.',
                      Colors.red,
                      Colors.white);
                  return;
                }

                // Extract roll numbers from the identified column
                for (var row in sheet.rows.skip(1)) {
                  // Skip header row
                  if (row.length > rollNumberColumnIndex) {
                    var cell = row[rollNumberColumnIndex];
                    if (cell != null) {
                      String cellValue = cell.toString().trim();
                      print(
                          'Raw cell value: $cellValue'); // Debugging statement

                      // Extract roll number based on its known format
                      String rollNumber = RegExp(r'\b[A-Z0-9]+\b')
                              .firstMatch(cellValue)
                              ?.group(0)
                              ?.trim()
                              .toUpperCase() ??
                          '';

                      if (rollNumber.isNotEmpty &&
                          !rollNumber.contains('DATA')) {
                        rollNumbers.add(rollNumber);
                      }
                    }
                  }
                }

                print('Cleaned roll numbers: $rollNumbers');

                // Check if roll numbers are extracted
                if (rollNumbers.isEmpty) {
                  _showCustomPopup(
                      context,
                      'Error',
                      'No valid roll numbers found in the Excel file.',
                      Colors.red,
                      Colors.white);
                  return;
                }

                // Delete data from Firestore
                await _deleteStudentsByRollNumbers(rollNumbers);

                // Show success message
                _showCustomPopup(
                    context,
                    'Success',
                    'Students with roll numbers have been deleted.',
                    Colors.green,
                    Colors.white);
              } else {
                _showCustomPopup(
                    context,
                    'Error',
                    'Excel file is empty or cannot be read.',
                    Colors.red,
                    Colors.white);
              }
            } else {
              _showCustomPopup(
                  context,
                  'Error',
                  'No sheets found in the Excel file.',
                  Colors.red,
                  Colors.white);
            }
          } else {
            _showCustomPopup(context, 'Error',
                'No sheets found in the Excel file.', Colors.red, Colors.white);
          }
        } catch (e) {
          _showCustomPopup(
              context,
              'Error',
              'Failed to process the Excel file. Please ensure it is in the correct format.',
              Colors.red,
              Colors.white);
          print('Error reading or processing file: $e');
        }
      } else {
        _showCustomPopup(
            context, 'Error', 'No file selected.', Colors.red, Colors.white);
      }
    });
  }

// Helper function to clean the column name
  String _cleanColumnName(String columnName) {
    final RegExp exp = RegExp(r'Data\(([^)]+)\)');
    final match = exp.firstMatch(columnName);
    return match != null
        ? match.group(1)?.split(',')[0].trim() ?? ''
        : columnName;
  }

  Future<void> _deleteStudentsByRollNumbers(List<String> rollNumbers) async {
    print("Starting the deletion process for roll numbers: $rollNumbers");

    for (String rollNumber in rollNumbers) {
      try {
        // Fetch documents with the specified roll number
        var querySnapshot = await FirebaseFirestore.instance
            .collection('Students')
            .where('Rollnumber', isEqualTo: rollNumber)
            .get();
        deleteRequestsByRollNumber(rollNumber);
        // Log the number of documents found
        print(
            'Found ${querySnapshot.docs.length} documents for roll number $rollNumber.');

        for (var doc in querySnapshot.docs) {
          print('Deleting document ID: ${doc.id}');
          final profilePictureUrl = doc['Profilepicture'];
          if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
            final storageRef = FirebaseStorage.instance.refFromURL(profilePictureUrl);
            await storageRef.delete();
          }
          await doc.reference.delete();
          
          print('Successfully deleted student with roll number $rollNumber');
        }

        // If no documents were found
        if (querySnapshot.docs.isEmpty) {
          print('No student found with roll number $rollNumber');
        }
      } catch (e) {
        print('Error deleting student with roll number $rollNumber: $e');
      }
    }

    print("Deletion process completed.");
  }

  Future<void> _incrementStudentYears() async {
    // Step 1: Show a confirmation dialog before performing the operation
    bool shouldProceed = await _showConfirmationPopup(context);

    // Step 2: If the user confirms, proceed with the operation
    if (shouldProceed) {
      try {
        // Delete students in the 4th year
        QuerySnapshot deleteSnapshot = await FirebaseFirestore.instance
            .collection('Students')
            .where('Year', isEqualTo: 4)
            .get();

        for (var doc in deleteSnapshot.docs) {
          await doc.reference.delete();
        }

        // Increment year for all remaining students
        QuerySnapshot updateSnapshot =
            await FirebaseFirestore.instance.collection('Students').get();

        for (var doc in updateSnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          int currentYear =
              data.containsKey('Year') ? (data['Year'] as int) : 0;
          await doc.reference.update({'Year': currentYear + 1});
        }

        // Show success popup after the operation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showCustomPopup(
              context,
              'Success',
              'Students data has been updated: 4th-year students deleted and remaining years incremented by 1.',
              Colors.green,
              Colors.white,
            );
          }
        });
      } catch (e) {
        // Show error popup if operation fails
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showCustomPopup(
              context,
              'Error',
              'Failed to update student data: $e',
              Colors.red,
              Colors.white,
            );
          }
        });
      }
    }
  }

// Function to show a confirmation popup
  Future<bool> _showConfirmationPopup(BuildContext context) async {
    bool proceed = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm to Increment Year of all Students'),
          content: Text(
              'This action will delete all 4th-year students and increment the year for all other students. Do you wish to proceed?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                proceed = true;
                Navigator.of(context).pop(true); // Confirm the action
              },
              child: Text('Proceed'),
            ),
          ],
        );
      },
    );
    return proceed;
  }

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _rollNumberController = TextEditingController();
  File? _image;

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _askForRollNumber();
    }
  }

  void _askForRollNumber() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Roll Number'),
          content: TextField(
            controller: _rollNumberController,
            decoration: InputDecoration(hintText: 'Roll Number'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _updateProfilePicture();
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateProfilePicture() async {
    if (_image == null) return;

    final rollNumber = _rollNumberController.text.trim().toUpperCase();
    if (rollNumber.isEmpty) {
      _showCustomPopup(context, 'Error', 'Roll Number cannot be empty!',
          Colors.red, Colors.white);

      return;
    }

    final storageRef = FirebaseStorage.instance.ref();
    final profilePicsRef =
        storageRef.child('profilepictures/Students/$rollNumber.png');

    try {
      // Fetch the document with the given roll number
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Students')
          .where('Rollnumber', isEqualTo: rollNumber)
          .get();
      // Fetch and delete the old image
      final oldImageUrl =
          querySnapshot.docs.first.data()['Profilepicture'] as String?;

      if (oldImageUrl != null) {
        final oldImageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
        await oldImageRef.delete();
      }
      // Upload the new profile picture
      await profilePicsRef.putFile(_image!);

      // Get the download URL
      final newImageUrl = await profilePicsRef.getDownloadURL();

      if (querySnapshot.docs.isEmpty) {
        _showCustomPopup(
            context,
            'Error',
            'No student found with this roll number.',
            Colors.red,
            Colors.white);
        return;
      }

      // Get the document ID (assuming there is only one matching document)
      final documentId = querySnapshot.docs.first.id;

      // Update the document with the new image URL
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(documentId)
          .update({'Profilepicture': newImageUrl});

      _showCustomPopup(context, 'Success',
          'Profile picture updated successfully!', Colors.green, Colors.white);
    } catch (e) {
      print('Error updating profile picture: $e');
      _showCustomPopup(context, 'Error', 'Failed to update profile picture.',
          Colors.red, Colors.white);
    }
  }

//   bool sw = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         child: AppBar(scrolledUnderElevation: 0,
//           elevation: 0,
//           centerTitle: true,
//           title: Text(
//             "OutPassIfy",
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: MediaQuery.of(context).size.width * 0.08,
//                 fontFamily: 'DancingScript'),
//           ),
//           leading: Container(
//             height: 50,
//             child: Image.asset(
//               'lib/images/logo3.png',
//               width: 500,
//             ),
//           ),
//           actions: <Widget>[
//             // IconButton(
//             //   onPressed: () {
//             //     GoRouter.of(context)
//             //         .pushNamed(MyAppRouteConstants.adminattendance); // Replace with your route name
//             //   },
//             //   icon: Image.asset(
//             //     'assets/icons/scanface.png', // Replace with the correct path to your scan logo
//             //     width: MediaQuery.of(context).size.width * 0.12, // Adjust size as needed
//             //     height: MediaQuery.of(context).size.width * 0.12, // Maintain aspect ratio
//             //   ),
//             // ),
//             IconButton(
//               padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
//               onPressed: () {
//                 GoRouter.of(context)
//                     .pushNamed(MyAppRouteConstants.adminpermissionRouteName);
//               },
//               icon: Icon(
//                 Icons.notifications,
//                 size: MediaQuery.of(context).size.width * 0.1,
//                 color: hasNotifications ? Colors.red : Colors.black,
//               ),
//             ),
//           ],
//           backgroundColor: Color(0x80CDD1E4),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(35),
//                   bottomRight: Radius.circular(35))),
//         ),
//         preferredSize: Size.fromHeight(MediaQuery.of(context).size.width * 0.2),
//       ),
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//             color: Color(0x80CDD1E4), borderRadius: BorderRadius.circular(20)),
//         margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.width * 0.2,
//                 width: double.infinity,
//                 decoration:
//                     BoxDecoration(borderRadius: BorderRadius.circular(20)),
//                 child: Center(
//                     child: Text(
//                   "Manage Students Data",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: MediaQuery.of(context).size.width * 0.08),
//                 )),
//                 margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               ),
//               SizedBox(height: 20), // Spacing between title and heading
//               Text(
//                 "Add Students",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: MediaQuery.of(context).size.width * 0.06,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20), // Spacing between title and buttons
//               ElevatedButton(
//                 onPressed: _showAddStudentDialog,
//                 child: Text(
//                   'Add Student Manually',
//                   style: TextStyle(
//                     color: Colors.black, // Set font color to black
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 15,
//                   ),
//                   textStyle: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width * 0.04,
//                   ),
//                 ),
//               ),

// // Spacing between title and heading
//               Text(
//                 "(OR)",
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: MediaQuery.of(context).size.width * 0.03,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               // Spacing between buttons
//               ElevatedButton(
//                 onPressed: _uploadFile,
//                 child: Text(
//                   'Upload Excel Sheet (.csv format)',
//                   style: TextStyle(
//                     color: Colors.black, // Set font color to black
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 15,
//                   ),
//                   textStyle: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width * 0.04,
//                   ),
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: ElevatedButton(
//                   onPressed: _showColumnNames,
//                   child: Text(
//                     'Preview Column Names',
//                     style: TextStyle(
//                       color: Colors.white, // Set font color to black
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 255, 113, 19),
//                     padding: EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.01,
//                         vertical: MediaQuery.of(context).size.width * 0.01),
//                     textStyle: TextStyle(
//                       fontSize: MediaQuery.of(context).size.width * 0.02,
//                     ),
//                   ),
//                 ),
//               ),

//               SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//               Text(
//                 "Delete Students",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: MediaQuery.of(context).size.width * 0.06,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20), // Add some spacing between the buttons
//               ElevatedButton(
//                 onPressed: _deleteStudentData,
//                 child: Text(
//                   'Delete Student Data Manually',
//                   style: TextStyle(
//                     color: Colors.black, // Font color set to black
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 15,
//                   ),
//                   textStyle: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width * 0.04,
//                   ),
//                 ),
//               ),
//               Text(
//                 "(OR)",
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontSize: MediaQuery.of(context).size.width * 0.03,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: _deletebyyear,
//                 child: Text(
//                   'Delete Students of specific year',
//                   style: TextStyle(
//                     color: Colors.black, // Font color set to black
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 15,
//                   ),
//                   textStyle: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width * 0.04,
//                   ),
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//               Text(
//                 "Change Student Profilepicture",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: MediaQuery.of(context).size.width * 0.06,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20), // Add some spacing between the buttons
//               ElevatedButton(
//                 onPressed: _pickImageFromGallery,
//                 child: Text(
//                   'Pick image from Gallery',
//                   style: TextStyle(
//                     color: Colors.black, // Font color set to black
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 15,
//                   ),
//                   textStyle: TextStyle(
//                     fontSize: MediaQuery.of(context).size.width * 0.04,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "Increment Students Year",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: MediaQuery.of(context).size.width * 0.06,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 20),
//               Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: _incrementStudentYears,
//                     child: Text(
//                       'Increment Year',
//                       style: TextStyle(
//                         color: Colors.black,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                       textStyle: TextStyle(
//                         fontSize: MediaQuery.of(context).size.width * 0.04,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20), // Spacing between button and text
//                   Align(
//                     alignment: Alignment.topRight,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           right: MediaQuery.of(context).size.width * 0.05),
//                       child: Text(
//                         '* After incrementing year, delete 4th year students by referring as 5th year',
//                         style: TextStyle(
//                           color: Color.fromARGB(255, 180, 2, 2),
//                           fontSize: MediaQuery.of(context).size.width * 0.03,
//                         ),
//                         textAlign: TextAlign.end,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
//         decoration: BoxDecoration(
//           color: Color(0x80CDD1E4), // Background color
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(35),
//             topRight: Radius.circular(35),
//           ),
//         ),
//         child: BottomNavigationBar(
//           elevation: 0,
//           type: BottomNavigationBarType.fixed,
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/icons/homeicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.04,
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/icons/inboxicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.05,
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/icons/settingsicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.045,
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 'assets/icons/profileicon.png',
//                 width: MediaQuery.of(context).size.width * 0.2,
//                 height: MediaQuery.of(context).size.height * 0.04,
//               ),
//               label: '',
//             ),
//           ],
//           currentIndex: currentIndex,
//           selectedItemColor: Colors.black,
//           unselectedItemColor: Colors.black,
//           onTap: onTapped,
//           iconSize: 40,
//           backgroundColor: Colors.transparent, // Remove the background color
//           // Align icons vertically
//           selectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
//           unselectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cards = [
      {'title': 'Add Student Manually', 'icon': Icons.person_add},
      {
        'title':
            'Upload Students data by uploading Excel file(Excel workbook format)',
        'icon': Icons.upload_file
      },
      {'title': 'Delete Student Manually', 'icon': Icons.delete},
      {
        'title':
            'Delete Students data by uploading Excel file(Excel workbook format)',
        'icon': Icons.upload_file
      },
      {'title': 'Update Student Profile picture', 'icon': Icons.photo_camera},
      {'title': 'Increment Year', 'icon': Icons.arrow_upward},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "OutPassIfy",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.08,
              fontFamily: 'DancingScript',
            ),
          ),
          leading: Container(
            height: 50,
            child: Image.asset(
              'lib/images/logo3.png',
              width: 50,
            ),
          ),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              onPressed: () {
                GoRouter.of(context)
                    .pushNamed(MyAppRouteConstants.adminpermissionRouteName);
              },
              icon: Icon(
                Icons.notifications,
                size: MediaQuery.of(context).size.width * 0.1,
                color: hasNotifications ? Colors.red : Colors.black,
              ),
            ),
          ],
          backgroundColor: Color(0x80CDD1E4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.width * 0.2),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0x80CDD1E4), borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Heading
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    "Manage Students Data",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Spacing between heading and grid

              // GridView of Buttons in Cards
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio:
                        1.0, // 1:1 aspect ratio for equal height and width
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return _buildCard(
                      card['title'],
                      card['icon'],
                      _getCardAction(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        decoration: BoxDecoration(
          color: Color(0x80CDD1E4), // Background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/homeicon.png',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/inboxicon.png',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/settingsicon.png',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.045,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/profileicon.png',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              label: '',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: onTapped,
          iconSize: 40,
          backgroundColor: Colors.transparent, // Remove the background color
          // Align icons vertically
          selectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
          unselectedLabelStyle: TextStyle(fontSize: 0), // Hide labels
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100, // Fixed height for cards
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40, // Size of the icon
                color: Colors.black,
              ),
              SizedBox(height: 10), // Space between icon and text
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCardTitle(int index) {
    switch (index) {
      case 0:
        return "Add Student Manually";
      case 1:
        return "Upload Excel Sheet (.csv format)";
      case 2:
        return "Delete Student Data Manually";
      case 3:
        return "Delete Students by uploading CSV file";
      case 4:
        return "Update Students Profile picture";
      case 5:
        return "Increment Year";
      default:
        return "";
    }
  }

  VoidCallback _getCardAction(int index) {
    switch (index) {
      case 0:
        return _showAddStudentDialog;
      case 1:
        return _uploadFile;
      case 2:
        return _deleteStudentData;
      case 3:
        return _uploadXlsx;
      case 4:
        return _pickImageFromGallery;
      case 5:
        return _incrementStudentYears;
      default:
        return () {};
    }
  }
}
