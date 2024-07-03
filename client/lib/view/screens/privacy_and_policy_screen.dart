import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8.0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '''Welcome to Udharo, a peer-to-peer lending platform designed to connect borrowers with lenders, facilitating seamless financial transactions. Udharo values your privacy and is committed to protecting your personal information. This Privacy Policy outlines how we collect, use, disclose, and safeguard your information when you use our application and services.

Information We Collect
Personal Information
We may collect personal information that you provide to us, including but not limited to:

Contact Information: Name, email address, phone number.
Identity Verification Information: Government-issued identification, date of birth.
Financial Information: Bank account details, transaction history, credit score.
Automatically Collected Information
We may collect certain information automatically when you use the app, including:

Device Information: IP address, browser type, operating system.
Usage Information: Pages viewed, actions taken within the app, time and date of usage.
How We Use Your Information
We use the information we collect in the following ways:

To Provide Services: Facilitate borrowing and lending transactions, process payments.
To Verify Identity: Ensure the security and integrity of transactions.
To Improve Services: Analyze usage patterns to enhance app functionality and user experience.
To Communicate: Send notifications, updates, and promotional materials.
How We Share Your Information
We may share your information with third parties only in the following circumstances:

Service Providers: With third-party vendors who perform services on our behalf, such as payment processing.
Legal Requirements: If required by law or in response to valid requests by public authorities.
Business Transfers: In the event of a merger, acquisition, or sale of all or a portion of our assets.
Data Security
We implement appropriate security measures to protect your personal information from unauthorized access, disclosure, alteration, and destruction. This includes the use of encryption, secure servers, and regular security assessments.

Your Rights and Choices
You have the right to:

Access Your Information: Request a copy of the personal information we hold about you.
Correct Your Information: Request corrections to any inaccurate or incomplete information.
Delete Your Information: Request the deletion of your personal information, subject to certain legal obligations.
Withdraw Consent: Withdraw your consent to the processing of your personal information at any time.
Data Retention
We retain your personal information only as long as necessary to fulfill the purposes outlined in this Privacy Policy or as required by law. When your information is no longer needed, we will securely delete or anonymize it.

Changes to This Privacy Policy
We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements. We will notify you of any material changes by posting the updated policy within the app and updating the "Last Updated" date at the top of this policy.

Contact Us
If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:

Email: privacy@udharo.com
Address: Udharo, 123 Finance Street, Kathmandu, Nepal.''',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
