import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
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
          seedColor: const Color(0xFFC9A8A3),
        ),
        // Romantic fonts with elegant styling
        textTheme: TextTheme(
          headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 32.0,
            color: const Color(0xFF7A6762),
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
          headlineSmall: GoogleFonts.playfairDisplay(
            fontSize: 26.0,
            color: const Color(0xFF7A6762),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
          titleLarge: GoogleFonts.cormorantGaramond(
            fontSize: 24.0,
            color: const Color(0xFF7A6762),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          titleMedium: GoogleFonts.cormorantGaramond(
            fontSize: 18.0,
            color: const Color(0xFF7A6762),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
          ),
          bodyLarge: GoogleFonts.cormorantGaramond(
            fontSize: 18.0,
            color: const Color(0xFF7A6762),
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
          bodyMedium: GoogleFonts.cormorantGaramond(
            fontSize: 16.0,
            color: const Color(0xFF7A6762),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            height: 1.5,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFFBF7F4),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.cormorantGaramond(
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
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
  // Romantic color palette - Soft and warm tones
  static const Color primaryColor = Color(0xFFC9A8A3);     // Soft taupe-brown
  static const Color secondaryColor = Color(0xFFDDB8C0);    // Soft rose
  static const Color accentColor = Color(0xFFF0DCD5);       // Very soft peach
  static const Color lightColor = Color(0xFFFAF1ED);        // Almost white cream
  static const Color whiteColor = Color(0xFFffffff);
  static const Color goldAccent = Color(0xFFE8D7C3);        // Soft warm gold
  static const Color heartColor = Color(0xFFE8BFCD);        // Soft pink

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

  Widget _buildAgendaItem(BuildContext context, String time, String activity) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF5D4D47),
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            activity,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B5A54),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    
    // Responsive header height
    double headerHeight = screenHeight * 0.45;
    if (headerHeight > 500) headerHeight = 500;
    if (isMobile && headerHeight < 300) headerHeight = 300;

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
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 30 : 34,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),

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
                                        fontSize: isMobile ? 30 : 34,
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
                                    fontSize: isMobile ? 30 : 34,
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
                                        fontSize: isMobile ? 30 : 34,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Se unen en matrimonio delante de Dios y sus seres queridos',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: whiteColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isMobile ? 18 : 22,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Countdown Timer Section - Dedicated and Prominent
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(isMobile ? 16 : 24),
              padding: EdgeInsets.all(isMobile ? 20 : 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withOpacity(0.8),
                    accentColor.withOpacity(0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: goldAccent.withOpacity(0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Faltan',
                    style: GoogleFonts.playfairDisplay(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                          fontSize: isMobile ? 32 : 44,
                        ),
                  ),
                  SizedBox(height: isMobile ? 16 : 20),
                  LayoutBuilder(builder: (context, constraints) {
                    final days = _timeRemaining.inDays;
                    final hours = _timeRemaining.inHours.remainder(24);
                    final minutes = _timeRemaining.inMinutes.remainder(60);
                    final seconds = _timeRemaining.inSeconds.remainder(60);

                    Widget valueBox(String label, String value, Color bgColor, {Color? accentColor}) {
                      return Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 16 : 20,
                                horizontal: isMobile ? 8 : 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    bgColor,
                                    (accentColor ?? bgColor).withOpacity(0.75),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: bgColor.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 8),
                                  ),
                                  BoxShadow(
                                    color: bgColor.withOpacity(0.1),
                                    blurRadius: 24,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    value,
                                    style: GoogleFonts.playfairDisplay(
                                          color: whiteColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: isMobile ? 28 : 36,
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                  SizedBox(height: isMobile ? 6 : 10),
                                  Text(
                                    label,
                                    style: GoogleFonts.cormorantGaramond(
                                          color: whiteColor.withOpacity(0.9),
                                          fontSize: isMobile ? 13 : 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        valueBox('Días', days.toString(), const Color(0xFFA89080), accentColor: const Color(0xFF967F6F)),
                        valueBox('Horas', hours.toString().padLeft(2, '0'), const Color(0xFFB8A090), accentColor: const Color(0xFFA68F7F)),
                        valueBox('Minutos', minutes.toString().padLeft(2, '0'), const Color(0xFFC8B0A0), accentColor: const Color(0xFFB69E8E)),
                        valueBox('Segundos', seconds.toString().padLeft(2, '0'), const Color(0xFFD8C0B0), accentColor: const Color(0xFFC6AEAE)),
                      ],
                    );
                  }),
                  SizedBox(height: isMobile ? 16 : 22),
                  Text(
                    'para el gran día',
                    style: GoogleFonts.cormorantGaramond(
                          color: primaryColor,
                          fontSize: isMobile ? 18 : 22,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Main content
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: isMobile ? 12 : 12,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Bible Verse Section
                Container(
                  padding: EdgeInsets.all(isMobile ? 18 : 24),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: isMobile ? 12 : 16),
                      Text(
                        '"El amor es sufrido, es benigno; el amor no es celoso, no es jactancioso, no es orgulloso; no es indecoroso, no busca lo suyo, no se irrita, no guarda rencor."\n\n1 Corintios 13:4-5',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: primaryColor,
                              fontStyle: FontStyle.italic,
                              height: 1.8,
                              fontSize: isMobile ? 18 : 22,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

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
                          '24 de Octubre de 2026',
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
                                fontWeight: FontWeight.w900,
                                fontSize: isMobile ? 25 : 30,
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
                        Wrap(
                          spacing: isMobile ? 8 : 16,
                          runSpacing: isMobile ? 12 : 16,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _launchUrl(mapsUrl),
                              icon: const Icon(Icons.map),
                              label: const Text('Google Maps'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: whiteColor,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 16,
                                  vertical: isMobile ? 10 : 12,
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 16,
                                  vertical: isMobile ? 10 : 12,
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

                // Agenda Section
                Card(
                  color: accentColor.withOpacity(0.6),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Agenda del Día',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: const Color(0xFF5D4D47),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 20),
                        // Timeline items
                        _buildAgendaItem(context, '2:30 p. m.', 'Cóctel de bienvenida'),
                        const SizedBox(height: 16),
                        _buildAgendaItem(context, '3:30 p. m.', 'Ceremonia nupcial'),
                        const SizedBox(height: 16),
                        _buildAgendaItem(context, '5:20 p. m.', 'Gran entrada, primer baile y brindis'),
                        const SizedBox(height: 16),
                        _buildAgendaItem(context, '5:45 p. m.', 'Cena'),
                        const SizedBox(height: 16),
                        _buildAgendaItem(context, '6:50 p. m.', 'Corte del pastel y tradiciones'),
                        const SizedBox(height: 16),
                        _buildAgendaItem(context, '7:15 p. m.', 'Despedida y salida de los novios'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // RSVP Section
                Container(
                  padding: EdgeInsets.all(isMobile ? 18 : 24),
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
                              fontSize: isMobile ? 23 : 29,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Completa el formulario para confirmar tu presencia en nuestro gran día',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: lightColor,
                              fontSize: isMobile ? 17 : 19,
                            ),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),
                      SizedBox(
                        width: double.infinity,
                        height: isMobile ? 48 : 56,
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
                                  fontSize: isMobile ? 17 : 19,
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
                    '¡Te esperamos con los brazos abiertos para celebrar juntos este día tan especial!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: primaryColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: isMobile ? 20 : 25,
                        ),
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
