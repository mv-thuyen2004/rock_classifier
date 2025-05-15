import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Không dùng context ở đây
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLanguage = context.locale.languageCode;
  }

  void changeLanguage(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
    });
    context.setLocale(Locale(languageCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change_language'.tr()),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('vietnamese'.tr()),
            trailing: selectedLanguage == 'vi' ? Icon(Icons.check, color: Colors.blue) : null,
            onTap: () => changeLanguage('vi'),
          ),
          ListTile(
            title: Text('english'.tr()),
            trailing: selectedLanguage == 'en' ? Icon(Icons.check, color: Colors.blue) : null,
            onTap: () => changeLanguage('en'),
          ),
        ],
      ),
    );
  }
}
