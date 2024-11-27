import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as encrypt;


Future<void> sendEmail(
    String email, String password, String Subject, String text) async {
  final smtpServer = SmtpServer('smtp.gmail.com',
      username: 'murakondacharansai24@gmail.com', // Replace with your email
      password: 'klmpraplpsjrrebw'); // Replace with your email password

  final message = Message()
    ..from = Address('murakondacharansai24@gmail.com',
        'Outpassify') // Replace with your email
    ..recipients.add(email)
    ..subject = Subject
    ..text = text + " " + '$password';
  try {
    final sendReport = await send(message, smtpServer);
    print(
        'EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEeEmail sent: ' +
            sendReport.toString());
    // await sendEmail(
    //   email,
    //   password,
    //   "Welcome to OutPassIfy",
    //   "Dear User,\n\n"
    //       "We are delighted to welcome you to OutPassIfy. Your account has been successfully created. "
    //       "Below are your account details:\n\n"
    //       "Username: ${email}\n"
    //       "Password: ${password}\n\n"
    //       "Please keep this information secure. We recommend changing your password upon your first login for added security.\n\n"
    //       "If you have any questions or need further assistance, please do not hesitate to contact our support team.\n\n"
    //       "Thank you for choosing OutPassIfy.\n\n"
    //       "Best regards,\n"
    //       "The OutPassIfy Team\n\n"
    //       "NOTE: Allow mails from Us with notification on clicking Looks Safe button.",
    // );
  } on MailerException catch (e) {
    print(
        'RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRrError sending email: $e');
  }
}
