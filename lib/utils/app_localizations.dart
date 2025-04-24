import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'app_name': 'My Barber',
      'loading': 'Loading...',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'error': 'Error',
      'success': 'Success',
      'warning': 'Warning',
      'minutes': 'minutes',
      'hours': 'hours',

      // Language
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'language_changed': 'Language changed successfully',

      // Home Screen
      'welcome': 'Welcome to My Barber',
      'queue_status': 'Queue Status',
      'current_number': 'Current Number',
      'your_number': 'Your Number',
      'estimated_wait': 'Estimated Wait Time',
      'people_ahead': 'People Ahead of You',
      'join_queue': 'Join Queue',
      'book_appointment': 'Book Appointment',
      'select_services': 'Select Services',
      'your_bookings': 'Your Bookings',

      // Service Selection
      'services': 'Services',
      'select_services_prompt': 'Please select the services you need',
      'haircut': 'Haircut',
      'beard_trim': 'Beard Trim',
      'blow_dry': 'Blow Dry',
      'hair_coloring': 'Hair Coloring',
      'shaving': 'Shaving',
      'face_treatment': 'Face Treatment',
      'children_haircut': 'Children Haircut',
      'estimated_duration': 'Estimated Duration',
      'total_price': 'Total Price',
      'continue': 'Continue',

      // Queue
      'queue_confirmation': 'Queue Confirmation',
      'queue_joined': 'You have successfully joined the queue',
      'queue_number': 'Your queue number is',
      'people_in_queue': 'People in queue',
      'estimated_wait_time': 'Estimated wait time',
      'mins': 'mins',
      'in_queue_message': 'You are in the queue. Please wait for your turn.',
      'almost_turn': 'It\'s almost your turn!',
      'now_serving': 'Now Serving',
      'leave_queue': 'Leave Queue',

      // Booking
      'book_for_later': 'Book for Later',
      'select_date': 'Select Date',
      'select_time': 'Select Time',
      'booking_confirmation': 'Booking Confirmation',
      'booking_confirmed': 'Your booking has been confirmed',
      'booking_details': 'Booking Details',
      'date': 'Date',
      'time': 'Time',
      'booking_services': 'Services',
      'booking_successful': 'Booking Successful',
      'arrive_by': 'Please arrive by',
      'no_bookings': 'You have no bookings',
      'cancel_booking': 'Cancel Booking',

      // Notifications
      'notification': 'Notification',
      'three_people_ahead': 'You have 3 people ahead in the queue',
      'two_people_ahead': 'You have 2 people ahead in the queue',
      'one_person_ahead': 'You have 1 person ahead in the queue',
      'your_turn_soon': 'Your turn is coming up soon!',
      'your_turn_now': 'It\'s your turn now!',
    },
    'ar': {
      // Common
      'app_name': 'حلاقي',
      'loading': 'جاري التحميل...',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'error': 'خطأ',
      'success': 'نجاح',
      'warning': 'تحذير',
      'minutes': 'دقائق',
      'hours': 'ساعات',

      // Language
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'language_changed': 'تم تغيير اللغة بنجاح',

      // Home Screen
      'welcome': 'مرحبًا بك في حلاقي',
      'queue_status': 'حالة الطابور',
      'current_number': 'الرقم الحالي',
      'your_number': 'رقمك',
      'estimated_wait': 'وقت الانتظار المقدر',
      'people_ahead': 'الأشخاص أمامك',
      'join_queue': 'انضم للطابور',
      'book_appointment': 'احجز موعد',
      'select_services': 'اختر الخدمات',
      'your_bookings': 'حجوزاتك',

      // Service Selection
      'services': 'الخدمات',
      'select_services_prompt': 'الرجاء اختيار الخدمات التي تحتاجها',
      'haircut': 'قص شعر',
      'beard_trim': 'تشذيب اللحية',
      'blow_dry': 'تجفيف بالهواء',
      'hair_coloring': 'صبغ الشعر',
      'shaving': 'حلاقة',
      'face_treatment': 'علاج الوجه',
      'children_haircut': 'قص شعر للأطفال',
      'estimated_duration': 'المدة المقدرة',
      'total_price': 'السعر الإجمالي',
      'continue': 'متابعة',

      // Queue
      'queue_confirmation': 'تأكيد الطابور',
      'queue_joined': 'لقد انضممت بنجاح إلى الطابور',
      'queue_number': 'رقمك في الطابور هو',
      'people_in_queue': 'أشخاص في الطابور',
      'estimated_wait_time': 'وقت الانتظار المقدر',
      'mins': 'دقائق',
      'in_queue_message': 'أنت في الطابور. الرجاء الانتظار لدورك.',
      'almost_turn': 'دورك قريبًا!',
      'now_serving': 'يتم خدمة الآن',
      'leave_queue': 'مغادرة الطابور',

      // Booking
      'book_for_later': 'احجز لوقت لاحق',
      'select_date': 'اختر التاريخ',
      'select_time': 'اختر الوقت',
      'booking_confirmation': 'تأكيد الحجز',
      'booking_confirmed': 'تم تأكيد حجزك',
      'booking_details': 'تفاصيل الحجز',
      'date': 'التاريخ',
      'time': 'الوقت',
      'booking_services': 'الخدمات',
      'booking_successful': 'تم الحجز بنجاح',
      'arrive_by': 'يرجى الوصول بحلول',
      'no_bookings': 'ليس لديك حجوزات',
      'cancel_booking': 'إلغاء الحجز',

      // Notifications
      'notification': 'إشعار',
      'three_people_ahead': 'لديك 3 أشخاص أمامك في الطابور',
      'two_people_ahead': 'لديك شخصان أمامك في الطابور',
      'one_person_ahead': 'لديك شخص واحد أمامك في الطابور',
      'your_turn_soon': 'دورك قادم قريباً!',
      'your_turn_now': 'حان دورك الآن!',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
