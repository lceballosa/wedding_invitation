import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  runApp(const WalterLauraApp());
}

class WalterLauraApp extends StatelessWidget {
  const WalterLauraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Walter & Laura - Wedding Invitation',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFb4947d),
        ),
        // Explicit TextTheme with concrete font sizes to avoid apply() issues
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28.0, color: Color(0xFF4b3a37)),
          headlineSmall: TextStyle(fontSize: 22.0, color: Color(0xFF4b3a37)),
          titleLarge: TextStyle(fontSize: 20.0, color: Color(0xFF4b3a37)),
          titleMedium: TextStyle(fontSize: 16.0, color: Color(0xFF4b3a37)),
          bodyLarge: TextStyle(fontSize: 16.0, color: Color(0xFF4b3a37)),
          bodyMedium: TextStyle(fontSize: 14.0, color: Color(0xFF4b3a37)),
        ),
        scaffoldBackgroundColor: const Color(0xFFfbf8f6),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const WeddingInvitationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeddingInvitationPage extends StatefulWidget {
  const WeddingInvitationPage({super.key});

  @override
  State<WeddingInvitationPage> createState() => _WeddingInvitationPageState();
}

class _WeddingInvitationPageState extends State<WeddingInvitationPage> {
  // Romantic color palette
  static const Color primaryColor = Color(0xFFb4947d);
  static const Color secondaryColor = Color(0xFFc7a49E);
  static const Color accentColor = Color(0xFFe4c9b8);
  static const Color lightColor = Color(0xFFe0d2c7);
  static const Color whiteColor = Color(0xFFffffff);

  // Google Forms URL for confirmation
  static const String googleFormsUrl =
      'https://docs.google.com/forms/d/e/1FAIpQLSe578DgNSzzznacVaxlkA-LVKqoIBOqTPm_vp489M0vZDRpfA/viewform?usp=sharing&ouid=113878454648420136929'; // Replace with actual form URL

  // Location coordinates for Hacienda Arkadia in Chia
  static const String mapsUrl =
      'https://maps.app.goo.gl/g2dLLBLfCGgMLL6FA?g_st=iw'; // Replace with actual location URL
  static const String wazeUrl =
      'https://waze.com/ul/hd2g7dqggh'; // Replace with actual Waze URL

  // Countdown timer state
  late Timer _countdownTimer;
  Duration _timeRemaining = Duration.zero;
  final DateTime _targetDate = DateTime(2026, 10, 24, 0, 0, 0);

  @override
  void initState() {
    super.initState();
    _updateTimeRemaining();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeRemaining();
    });
  }

  void _updateTimeRemaining() {
    final now = DateTime.now();
    final remaining = _targetDate.difference(now);
    setState(() {
      _timeRemaining = remaining.isNegative ? Duration.zero : remaining;
    });
  }

  String _formatDuration(Duration d) {
    if (d <= Duration.zero) return '¡Es el día!';
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  // Reusable time box with smooth value transition
  Widget _buildTimeBox(String label, String value, Color bg, {bool compact = false}) {
    final valueStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: whiteColor,
          fontWeight: FontWeight.w800,
          fontSize: compact ? 16 : 20,
        );
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: whiteColor.withOpacity(0.95),
          fontSize: compact ? 11 : 12,
        );

    return Container(
      padding: EdgeInsets.symmetric(vertical: compact ? 8 : 14, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bg, bg.withOpacity(0.85)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: Text(
              value,
              key: ValueKey(value),
              style: valueStyle,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: labelStyle),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // responsive header height (cap to avoid excessive height)
    double headerHeight = screenHeight * 0.50;
    if (headerHeight > 480) headerHeight = 480;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with decorative background image and soft overlay
          SliverAppBar(
            expandedHeight: headerHeight,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // background image (make sure asset exists)
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/anillo.jpeg'),
                        fit: BoxFit.cover,
                        opacity: 0.95,
                      ),
                    ),
                  ),
                  // soft vignette overlay to improve text contrast
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryColor.withOpacity(0.38),
                          secondaryColor.withOpacity(0.18),
                        ],
                      ),
                    ),
                  ),
                  // header content
                  SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 14),

                            // Names (scale down if needed)
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Walter Díaz',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.6,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '&',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: accentColor,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 28,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Laura Ceballos',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1.6,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Se unen en matrimonio',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: lightColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                            const SizedBox(height: 14),
                            // Compact countdown inside header
                            LayoutBuilder(builder: (context, constraints) {
                              final days = _timeRemaining.inDays;
                              final hours = _timeRemaining.inHours.remainder(24);
                              final minutes = _timeRemaining.inMinutes.remainder(60);
                              final seconds = _timeRemaining.inSeconds.remainder(60);

                              Widget valueBox(String label, String value, Color bgColor) {
                                return SizedBox(
                                  width: (constraints.maxWidth - 48) / 4,
                                  child: _buildTimeBox(label, value, bgColor, compact: false),
                                );
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  valueBox('Días', days.toString(), primaryColor),
                                  valueBox('Horas', hours.toString().padLeft(2, '0'), secondaryColor),
                                  valueBox('Min', minutes.toString().padLeft(2, '0'), accentColor),
                                  valueBox('Seg', seconds.toString().padLeft(2, '0'), lightColor.withOpacity(0.9)),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                               // Date and Time Section
                Card(
                  color: accentColor.withOpacity(0.6),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Fecha y Hora',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '26 de Octubre de 2026',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '2:30 PM',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: secondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Location Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Ubicación',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Hacienda Arkadia',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chía, Cundinamarca',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: secondaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _launchUrl(mapsUrl),
                              icon: const Icon(Icons.map),
                              label: const Text('Google Maps'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: whiteColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _launchUrl(wazeUrl),
                              icon: const Icon(Icons.navigation),
                              label: const Text('Waze'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                                foregroundColor: whiteColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // RSVP Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.8),
                        secondaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Confirma tu Asistencia',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Completa el formulario para confirmar tu presencia en nuestro gran día',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: lightColor,
                            ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => _launchUrl(googleFormsUrl),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: primaryColor,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Confirmar Asistencia',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Footer message
                Center(
                  child: Text(
                    '✨ Esperamos tu presencia ✨',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: primaryColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
