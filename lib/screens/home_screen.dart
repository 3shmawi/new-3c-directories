import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/queue_provider.dart';
import '../../utils/app_localizations.dart';
import '../../widgets/queue_status_card.dart';
import '../service_selection_screen.dart';
import '../widgets/language_selector.dart';
import 'bookings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final languageProvider = Provider.of<LanguageProvider>(context);
    final queueProvider = Provider.of<QueueProvider>(context);
    final isArabic = true;
    final localizations = AppLocalizations.of(context);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        localizations.translate('app_name'),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            "https://images.unsplash.com/photo-1745437980540-b234c90a6557?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw4fHx8ZW58MHx8fHx8",
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: LanguageSelector(),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.translate('welcome'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 24),

                          // Queue Status Card
                          QueueStatusCard(),

                          const SizedBox(height: 32),

                          // Action Buttons
                          Text(
                            localizations.translate('services'),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),

                          // Main Action Buttons
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.1,
                            children: [
                              _buildActionCard(
                                context,
                                Icons.content_cut,
                                localizations.translate('join_queue'),
                                Theme.of(context).colorScheme.primary,
                                () =>
                                    _navigateToServiceSelection(context, true),
                              ),
                              _buildActionCard(
                                context,
                                Icons.calendar_today,
                                localizations.translate('book_appointment'),
                                Theme.of(context).colorScheme.tertiary,
                                () =>
                                    _navigateToServiceSelection(context, false),
                              ),
                              _buildActionCard(
                                context,
                                Icons.list_alt,
                                localizations.translate('your_bookings'),
                                Theme.of(context).colorScheme.secondary,
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BookingsScreen(),
                                  ),
                                ),
                              ),
                              _buildActionCard(
                                context,
                                Icons.settings,
                                localizations.translate('select_services'),
                                Colors.grey[700]!,
                                () =>
                                    _navigateToServiceSelection(context, null),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String text,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToServiceSelection(BuildContext context, bool? isJoinQueue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceSelectionScreen(isJoinQueue: isJoinQueue),
      ),
    );
  }
}
