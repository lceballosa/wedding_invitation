import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with decorative background
          SliverAppBar(
            // Make header taller (45% of screen height)
            expandedHeight: screenHeight * 0.8,
            floating: false,
            pinned: true,
            backgroundColor: primaryColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/anillo.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                // overlay a subtle tint so text is readable on the image
                child: Container(
                  color: primaryColor.withOpacity(0.28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Walter Díaz',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: whiteColor,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '&',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w300,
                              fontSize: 28,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Laura Ceballos',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: whiteColor,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Se unen en matrimonio',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: lightColor,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Date and Time Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                const SizedBox(height: 24),

                // Location Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: lightColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
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
