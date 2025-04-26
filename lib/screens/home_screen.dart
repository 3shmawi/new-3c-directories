import 'package:flutter/material.dart';
import 'package:new_3c/app/extensions/localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/queue_provider.dart';
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

    return Scaffold(
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
                      context.translate('app_name'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "https://images.pexels.com/photos/3993132/pexels-photo-3993132.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(context).colorScheme.primary,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            );
                          },
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
                          context.translate('welcome'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 24),

                        // Queue Status Card
                        QueueStatusCard(),

                        const SizedBox(height: 32),

                        // Action Buttons
                        Text(
                          context.translate('services'),
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
                              context.translate('join_queue'),
                              Theme.of(context).colorScheme.primary,
                              () => _navigateToServiceSelection(context, true),
                            ),
                            _buildActionCard(
                              context,
                              Icons.calendar_today,
                              context.translate('book_appointment'),
                              Theme.of(context).colorScheme.tertiary,
                              () => _navigateToServiceSelection(context, false),
                            ),
                            _buildActionCard(
                              context,
                              Icons.list_alt,
                              context.translate('your_bookings'),
                              Theme.of(context).colorScheme.secondary,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BookingsScreen(),
                                ),
                              ),
                            ),
                            _buildActionCard(
                              context,
                              Icons.settings,
                              context.translate('select_services'),
                              Colors.grey[700]!,
                              () => _navigateToServiceSelection(context, null),
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
