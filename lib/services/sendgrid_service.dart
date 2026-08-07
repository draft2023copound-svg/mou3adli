import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class SendGridService {
  static const String _apiKey = String.fromEnvironment('SENDGRID_API_KEY');

  static const String _fromEmail = 'support.mou3adli@gmail.com';
  static const String _fromName = 'Mou3adli';
  static const String _templateId = 'd-4196f49e8665402ebae4ea434026a05a';

  static Future<bool> sendPasswordResetEmail({
    required String toEmail,
    required String resetToken,
    required String userName,
  }) async {
    try {
      final resetUrl = 'https://mou3adli.app/reset-password?token=$resetToken';
      
      final response = await http.post(
        Uri.parse('https://api.sendgrid.com/v3/mail/send'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'personalizations': [
            {
              'to': [
                {'email': toEmail}
              ],
              'dynamic_template_data': {
                'user_name': userName,
                'reset_url': resetUrl,
              }
            }
          ],
          'from': {
            'email': _fromEmail,
            'name': _fromName,
          },
          'template_id': _templateId,
        }),
      );

      return response.statusCode == 202;
    } catch (e) {
      debugPrint('Erreur SendGrid: $e');
      return false;
    }
  }

  static Future<bool> sendPasswordResetEmailSimple({
    required String toEmail,
    required String resetToken,
    required String userName,
  }) async {
    try {
      final resetUrl = 'https://mou3adli.app/reset-password?token=$resetToken';
      
      final response = await http.post(
        Uri.parse('https://api.sendgrid.com/v3/mail/send'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'personalizations': [
            {
              'to': [
                {'email': toEmail}
              ],
            }
          ],
          'from': {
            'email': _fromEmail,
            'name': _fromName,
          },
          'subject': 'Réinitialisation de votre mot de passe - Mou3adli',
          'content': [
            {
              'type': 'text/html',
              'value': '''<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Réinitialisation de mot de passe</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #F5F7FB;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background-color: #F5F7FB; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table width="600" cellpadding="0" cellspacing="0" style="background-color: #ffffff; border-radius: 24px; overflow: hidden; box-shadow: 0 10px 40px rgba(0,0,0,0.08);">
          <!-- Header -->
          <tr>
            <td style="background: linear-gradient(135deg, #1C3F7A 0%, #2563EB 100%); padding: 40px; text-align: center;">
              <img src="https://ton-domaine.com/assets/images/logo.png" alt="Mou3adli" width="80" style="margin-bottom: 16px;">
              <h1 style="color: #ffffff; font-size: 24px; font-weight: 800; margin: 0;">Mou3adli</h1>
              <p style="color: rgba(255,255,255,0.8); font-size: 14px; margin: 8px 0 0 0;">معادلي</p>
            </td>
          </tr>
          <!-- Content -->
          <tr>
            <td style="padding: 40px;">
              <h2 style="color: #1E293B; font-size: 20px; font-weight: 700; margin: 0 0 16px 0;">Bonjour $userName,</h2>
              <p style="color: #64748B; font-size: 16px; line-height: 1.6; margin: 0 0 24px 0;">
                Vous avez demandé à réinitialiser votre mot de passe pour votre compte Mou3adli. Cliquez sur le bouton ci-dessous pour choisir un nouveau mot de passe.
              </p>
              <table width="100%" cellpadding="0" cellspacing="0" style="margin: 32px 0;">
                <tr>
                  <td align="center">
                    <a href="$resetUrl" style="display: inline-block; background: linear-gradient(135deg, #1C3F7A 0%, #2563EB 100%); color: #ffffff; text-decoration: none; padding: 16px 40px; border-radius: 16px; font-weight: 700; font-size: 16px;">
                      Réinitialiser mon mot de passe
                    </a>
                  </td>
                </tr>
              </table>
              <p style="color: #94A3B8; font-size: 14px; line-height: 1.5; margin: 24px 0 0 0;">
                Si vous n'avez pas demandé cette réinitialisation, vous pouvez ignorer cet email. Le lien expirera dans 1 heure pour des raisons de sécurité.
              </p>
              <p style="color: #94A3B8; font-size: 14px; margin: 16px 0 0 0;">
                L'équipe Mou3adli 💙
              </p>
            </td>
          </tr>
          <!-- Footer -->
          <tr>
            <td style="background-color: #F8FAFC; padding: 24px; text-align: center; border-top: 1px solid #E2E8F0;">
              <p style="color: #94A3B8; font-size: 12px; margin: 0;">
                © 2026 Mou3adli. Tous droits réservés.<br>
                <a href="mailto:support.mou3adli@gmail.com" style="color: #2563EB; text-decoration: none;">support.mou3adli@gmail.com</a>
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
              '''
            }
          ],
        }),
      );

      return response.statusCode == 202;
    } catch (e) {
      debugPrint('Erreur SendGrid: $e');
      return false;
    }
  }
}
