import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:intl/intl.dart';
import 'package:crypton/crypton.dart';

class Mailer {
  RSAKeypair _rsaKeypair = RSAKeypair.fromRandom();
  String _password = '4m4M4k3M0n3y\$';

  String _encrypted;

  void _setEncrypt () {
    _encrypted = _rsaKeypair.publicKey.encrypt(_password);
  }

  emailSender({@required String emailRecipient, @required List<String> paths}) async {
    _setEncrypt();
    String username = 'diego.molina.sieiro@gmail.com';
    String password = _rsaKeypair.privateKey.decrypt(_encrypted);
    //String password = _password;

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    Message message = Message()
      ..from = Address(username, 'Abasto sin Gasto')
      ..recipients.add(emailRecipient)
      ..ccRecipients.addAll(['diego.molina@mosifin.tech'])
      ..subject = 'Pedidos: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'
      ..html = "<h1>Hola:</h1>\n<p>Abajo encontrarás los pdf's que corresponden con los pedidos de hoy</p>\n<h2>Saludos, Abasto sin Gasto</h2>";

    for (String path in paths) {
      message
        ..attachments.add(
          FileAttachment(
            File(
              path,
            ),
          ),
        );
    }

    /*try {
      final sendReport = await send(message, smtpServer);
    } on MailerException catch (e) {
      for (var p in e.problems) {
      }
    }*/
    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // send the equivalent message
    //await connection.send(equivalentMessage);

    // close the connection
    await connection.close();
  }
}