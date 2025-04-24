import 'package:flutter/material.dart';

import '../utils/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = true;
    final localizations = AppLocalizations.of(context);

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
              padding: EdgeInsets.all(4),
              child: Text(
                isArabic ? 'ع' : 'En',
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
      tooltip: localizations.translate('language'),
      onSelected: (String langCode) {
        // languageProvider.setLocale(Locale(langCode));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.translate('language_changed')),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: Duration(seconds: 2),
            action: SnackBarAction(
              label: localizations.translate('confirm'),
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
                  color: isArabic
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.primary,
                ),
                child: isArabic
                    ? null
                    : Icon(Icons.check, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Text(localizations.translate('english')),
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
                  color: isArabic
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
                child: isArabic
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(localizations.translate('arabic')),
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
