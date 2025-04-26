import 'package:flutter/material.dart';
import 'package:new_3c/app/enums/languages.dart';
import 'package:new_3c/app/extensions/localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final languageProvider = Provider.of<LanguageProvider>(context);

    return PopupMenuButton<String>(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.language,
            color: Colors.white,
            size: 28,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(2),
              child: Text(
                context.isArabic() ? Languages.ar.code : Languages.en.code,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      tooltip: context.translate('language'),
      onSelected: (String langCode) {
        context
            .changeLanguage(context.isArabic() ? Languages.en : Languages.ar);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.translate('language_changed')),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: context.translate('confirm'),
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.isArabic()
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.primary,
                ),
                child: context.isArabic()
                    ? null
                    : Icon(Icons.check, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Text(context.translate('english')),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'ar',
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.isArabic()
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
                child: context.isArabic()
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(context.translate('arabic')),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      offset: const Offset(0, 40),
      elevation: 4,
      color: Theme.of(context).cardTheme.color,
    );
  }
}
