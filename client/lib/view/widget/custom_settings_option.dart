import 'package:flutter/material.dart';

class CustomSettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget widget;
  final bool isDialog;
  const CustomSettingsOption({
    super.key,
    required this.icon,
    required this.title,
    required this.widget,
    this.isDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
          ),
          onTap: () {
            if(isDialog){
              showDialog(
                context: context,
                builder: (context) => widget,
              );
              return;
            }
            else{
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => widget,
              ),
            );
            }
            
          },
        ),
        const Divider(),
      ],
    );
  }
}
