import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class LauncherService {
  // Appeler un numéro de téléphone
  static Future<void> makePhoneCall(
      String phoneNumber, BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showError(
            context,
            'Application téléphone non disponible.\n'
            'Testez sur un appareil réel ou un émulateur avec Google Play.');
      }
    } catch (e) {
      _showError(context, 'Erreur lors de l\'appel: $e');
    }
  }

  // Envoyer un SMS
  static Future<void> sendSMS(String phoneNumber, BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showError(
            context,
            'Application messages non disponible.\n'
            'Testez sur un appareil réel ou un émulateur avec Google Play.');
      }
    } catch (e) {
      _showError(context, 'Erreur lors de l\'envoi du SMS: $e');
    }
  }

  // Envoyer un email
  static Future<void> sendEmail(String email, BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showError(
            context,
            'Application email non disponible.\n'
            'Testez sur un appareil réel ou un émulateur avec Google Play.');
      }
    } catch (e) {
      _showError(context, 'Erreur lors de l\'envoi de l\'email: $e');
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.orange[800],
      ),
    );
  }
}
