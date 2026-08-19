// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:html' as html;

void main() => runApp(const WalterLauraApp());

// ── Design Tokens ─────────────────────────────────────────────────────────────
const _surfaceCream          = Color(0xFFF4F1EA);
const _textCharcoal          = Color(0xFF2A2E2A);
const _textMuted             = Color(0xFF9EA69C);
const _accentGold            = Color(0xFFD4AF37);
const _sageGreen             = Color(0xFF7A8B76);
const _primary               = Color(0xFF50604D);
const _surfaceContainerLow   = Color(0xFFF5F3F0);
const _surfaceContainerHigh  = Color(0xFFEAE8E5);
const _onSurfaceVariant      = Color(0xFF444842);
const _outlineVariant        = Color(0xFFC4C8BF);

TextStyle _g(double sz, {
  FontWeight fw = FontWeight.w400,
  FontStyle fs = FontStyle.normal,
  double? h, double? ls,
  Color c = _textCharcoal,
}) => GoogleFonts.ebGaramond(fontSize: sz, fontWeight: fw, fontStyle: fs, height: h, letterSpacing: ls, color: c);

TextStyle _m(double sz, {
  FontWeight fw = FontWeight.w400,
  FontStyle fs = FontStyle.normal,
  double? h, double? ls,
  Color c = _textCharcoal,
}) => GoogleFonts.montserrat(fontSize: sz, fontWeight: fw, fontStyle: fs, height: h, letterSpacing: ls, color: c);

// ── App ───────────────────────────────────────────────────────────────────────
class WalterLauraApp extends StatelessWidget {
  const WalterLauraApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Walter & Laura - Invitación de Boda',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: _surfaceCream,
          colorScheme: const ColorScheme.light(
            primary: _sageGreen,
            secondary: _accentGold,
            surface: Color(0xFFFBF9F6),
            onSurface: _textCharcoal,
          ),
        ),
        home: const _InvitePage(),
        debugShowCheckedModeBanner: false,
      );
}

// ── Page ──────────────────────────────────────────────────────────────────────
class _InvitePage extends StatefulWidget {
  const _InvitePage();
  @override
  State<_InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<_InvitePage> {
  static const _mapsUrl = 'https://maps.app.goo.gl/g2dLLBLfCGgMLL6FA?g_st=iw';
  static const _wazeUrl = 'https://waze.com/ul/hd2g7dqggh';

  final _wedding    = DateTime(2026, 10, 24, 14, 30);
  late Timer        _timer;
  Duration          _left = Duration.zero;

  String?           _attendance;
  bool              _galleryExpanded = false;
  final _nameCtrl   = TextEditingController();
  final _scroll     = ScrollController();

  final _heroKey    = GlobalKey();
  final _locKey     = GlobalKey();
  final _galleryKey = GlobalKey();
  final _rsvpKey    = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final r = _wedding.difference(DateTime.now());
    setState(() => _left = r.isNegative ? Duration.zero : r);
  }

  @override
  void dispose() {
    _timer.cancel();
    _nameCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication) && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No se pudo abrir el enlace')));
    }
  }

  void _goto(GlobalKey k) {
    final ctx = k.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _surfaceCream,
        appBar: _appBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scroll,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _hero(),
                        _eventInfo(),
                        _divider(),
                        _location(),
                        _gallery(),
                        _verse(),
                        _infoSection(),
                        _rsvp(),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _floatingCTA(),
          ],
        ),
        bottomNavigationBar: _bottomNav(),
      );

  // ─── App Bar ──────────────────────────────────────────────────────────────
  PreferredSizeWidget _appBar() => AppBar(
        backgroundColor: _surfaceCream,
        elevation: 2,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Text('Walter & Laura', style: _g(28, c: _primary)),
          ],
        ),
      );

  // ─── Hero ─────────────────────────────────────────────────────────────────
  Widget _hero() => Column(
        key: _heroKey,
        children: [
          const SizedBox(height: 48),
          Text(
            'ÚNETE A NUESTRA CELEBRACIÓN',
            textAlign: TextAlign.center,
            style: _m(13, fw: FontWeight.w300, ls: 2.6, c: _textMuted),
          ),
          const SizedBox(height: 24),
          Text('Walter Díaz',
              style: _g(48, fw: FontWeight.w500, h: 1.2)),
          Text('&',
              style: _g(60, fw: FontWeight.w400, h: 1.0, fs: FontStyle.italic, c: _accentGold)),
          Text('Laura Ceballos',
              style: _g(48, fw: FontWeight.w500, h: 1.2)),
          const SizedBox(height: 32),
          _arch('assets/portada2.jpg', maxW: 400),
          const SizedBox(height: 48),
        ],
      );

  // ─── Event Info + Countdown ───────────────────────────────────────────────
  Widget _eventInfo() {
    final d = _left.inDays;
    final h = _left.inHours.remainder(24);
    final m = _left.inMinutes.remainder(60);
    final s = _left.inSeconds.remainder(60);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('24',   style: _g(32, fw: FontWeight.w400, ls: 3.0, c: const Color(0xCC2A2E2A))),
          const SizedBox(width: 24),
          Container(width: 1, height: 32, color: const Color(0x4DD4AF37)),
          const SizedBox(width: 24),
          Text('10',   style: _g(32, fw: FontWeight.w400, ls: 3.0, c: const Color(0xCC2A2E2A))),
          const SizedBox(width: 24),
          Container(width: 1, height: 32, color: const Color(0x4DD4AF37)),
          const SizedBox(width: 24),
          Text('2026', style: _g(32, fw: FontWeight.w400, ls: 3.0, c: const Color(0xCC2A2E2A))),
        ],
      ),
      const SizedBox(height: 24),
      Text('Hacienda Arkadia',    style: _g(32, fw: FontWeight.w500, h: 1.3)),
      const SizedBox(height: 8),
      Text('CHÍA, CUNDINAMARCA',  style: _m(13, fw: FontWeight.w300, ls: 3.9, c: _sageGreen)),
      const SizedBox(height: 16),
      Text('2:30 PM',             style: _g(32, fw: FontWeight.w500, h: 1.3, c: _primary)),
      const SizedBox(height: 48),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _cbox(d.toString(),              'DÍAS'),
          const SizedBox(width: 16),
          _cbox(h.toString().padLeft(2,'0'), 'HORAS'),
          const SizedBox(width: 16),
          _cbox(m.toString().padLeft(2,'0'), 'MIN'),
          const SizedBox(width: 16),
          _cbox(s.toString().padLeft(2,'0'), 'SEG'),
        ],
      ),
      const SizedBox(height: 32),
      const Icon(Icons.favorite, color: _accentGold, size: 36),
      const SizedBox(height: 24),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Text(
          'Todo comenzó en el corazón de Dios.\n\n'
          'Él escribió nuestra historia, fortaleció nuestro amor y nos condujo hasta este día.\n\n'
          'Con alegría, queremos compartir con ustedes este momento tan especial en el que, '
          'bajo Su gracia y dirección, uniremos nuestras vidas para caminar juntos conforme a Su propósito.',
          textAlign: TextAlign.center,
          style: _m(16, h: 1.6),
        ),
      ),
      const SizedBox(height: 120),
    ]);
  }

  Widget _cbox(String val, String lbl) => Container(
        constraints: const BoxConstraints(minWidth: 70),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _sageGreen,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Column(children: [
          Text(val, style: _g(32, fw: FontWeight.w500, h: 1.0, c: _surfaceCream)),
          const SizedBox(height: 4),
          Text(lbl, style: _m(11, ls: 1.65, c: const Color(0xCCF4F1EA))),
        ]),
      );

  // ─── Section Divider ──────────────────────────────────────────────────────
  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Divider(
                color: const Color(0x4D7A8B76), thickness: 0.5, endIndent: 16)),
            SizedBox(width: 60, height: 24, child: CustomPaint(painter: _LeafPainter())),
            Expanded(
              child: Divider(
                color: const Color(0x4D7A8B76), thickness: 0.5, indent: 16)),
          ],
        ),
      );

  // ─── Location ─────────────────────────────────────────────────────────────
  Widget _location() => Column(
        key: _locKey,
        children: [
          const SizedBox(height: 24),
          _arch('assets/67.jpg', maxW: 300),
          const SizedBox(height: 32),
          Text('El Lugar',
              style: _g(48, fw: FontWeight.w500, h: 1.2, c: _primary)),
          const SizedBox(height: 24),
          Text('Hacienda Arkadia\nChía, Cundinamarca',
              textAlign: TextAlign.center, style: _m(16, h: 1.6)),
          const SizedBox(height: 8),
          Text('Sábado, 24 de Octubre de 2026\n2:30 PM',
              textAlign: TextAlign.center,
              style: _m(16, h: 1.6, c: _sageGreen)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16, runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _pill('GOOGLE MAPS', Icons.map,       _sageGreen,              _surfaceCream,  () => _open(_mapsUrl)),
              _pill('WAZE',        Icons.navigation, const Color(0xFFDBDAD7), _textCharcoal, () => _open(_wazeUrl)),
            ],
          ),
          const SizedBox(height: 130),
        ],
      );

  Widget _pill(String lbl, IconData icon, Color bg, Color fg, VoidCallback fn) =>
      GestureDetector(
        onTap: fn,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: 12),
              Text(lbl, style: _m(13, fw: FontWeight.w500, ls: 2.6, c: fg)),
            ],
          ),
        ),
      );

  // ─── Gallery ──────────────────────────────────────────────────────────────
  Widget _gallery() {
    const photos = [
      'assets/anillo.jpeg',
      'assets/abrazo.jpeg',
      'assets/29-.jpg',
      'assets/37.jpg',
      'assets/43.jpg',
      'assets/48.jpg',
      'assets/55.jpg',
      'assets/68.jpg',
      'assets/60.jpg',
      'assets/34.jpg',
      'assets/23.jpg',
      'assets/14.jpg',
      'assets/12B-.jpg',
      'assets/5-.jpg',
    ];

    Widget col(List<String> assets, {double topOffset = 0}) => Padding(
          padding: EdgeInsets.only(top: topOffset),
          child: Column(
            children: [
              for (var i = 0; i < assets.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      color: _surfaceContainerHigh,
                      child: Image.asset(
                        assets[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              color: _textMuted, size: 32)),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );

    final allLeft  = [for (var i = 0; i < photos.length; i += 2) photos[i]];
    final allRight = [for (var i = 1; i < photos.length; i += 2) photos[i]];
    final left  = _galleryExpanded ? allLeft  : allLeft.sublist(0, 2);
    final right = _galleryExpanded ? allRight : allRight.sublist(0, 2);

    return Column(
      key: _galleryKey,
      children: [
        Text('Momentos Juntos', style: _g(32, fw: FontWeight.w500, h: 1.3)),
        const SizedBox(height: 8),
        Text('Un vistazo a nuestra historia de amor',
              style: _m(13, fw: FontWeight.w300, ls: 2.6, c: _textMuted)),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: col(left)),
            const SizedBox(width: 16),
            Expanded(child: col(right, topOffset: 32)),
          ],
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () => setState(() => _galleryExpanded = !_galleryExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: _sageGreen,
              borderRadius: BorderRadius.circular(9999),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _galleryExpanded ? Icons.expand_less : Icons.photo_library,
                  color: _surfaceCream, size: 20),
                const SizedBox(width: 12),
                Text(
                  _galleryExpanded ? 'VER MENOS' : 'VER ÁLBUM COMPLETO',
                  style: _m(13, fw: FontWeight.w500, ls: 2.6, c: _surfaceCream)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  // ─── Bible Verse ──────────────────────────────────────────────────────────
  Widget _verse() => Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: _surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x0D7A8B76), blurRadius: 40, offset: Offset(0, 10)),
          ],
        ),
        child: Column(children: [
          Text(
            '"El amor es sufrido, es benigno; el amor no es celoso, no es jactancioso, '
            'no es orgulloso; no es indecoroso, no busca lo suyo, no se irrita, no guarda rencor."',
            textAlign: TextAlign.center,
            style: _g(32, fw: FontWeight.w500, h: 1.3, fs: FontStyle.italic, c: _sageGreen),
          ),
          const SizedBox(height: 24),
          Text('1 CORINTIOS 13:4-5',
              style: _m(13, fw: FontWeight.w300, ls: 2.6, c: _textMuted)),
        ]),
      );

  // ─── Información Importante ───────────────────────────────────────────────
  Widget _infoSection() {
    const items = [
      (Icons.checkroom,      'CÓDIGO DE VESTIMENTA',        'Etiqueta formal. Agradecemos asistir con vestido largo o traje formal. Para conservar la elegancia de la ocasión, recomendamos evitar calzado deportivo.'),
      (Icons.person_add,     'INVITACIÓN PERSONAL',         'Hemos preparado esta celebración con mucho amor y cuidado. Por ello, agradecemos que nos acompañen únicamente las personas incluidas en esta invitación.'),
      (Icons.schedule,       'PUNTUALIDAD',                 'Nuestra ceremonia iniciará a la hora indicada. Les agradecemos llegar con anticipación para compartir juntos cada momento de esta ocasión tan especial.'),
      (Icons.how_to_reg,     'CONFIRMACIÓN DE ASISTENCIA',  'Por favor, confirmen su asistencia antes de la fecha señalada.'),
      (Icons.phonelink_ring, 'CEREMONIA SIN DISTRACCIONES', 'Les invitamos a disfrutar plenamente de la ceremonia, manteniendo sus dispositivos móviles en silencio.'),
      (Icons.redeem,         'LLUVIA DE SOBRES',            'Su presencia será nuestro mejor regalo. Sin embargo, si desean bendecirnos con un obsequio, hemos elegido la modalidad de lluvia de sobres.'),
    ];
    return Column(
      children: [
        const SizedBox(height: 48),
        Text('Información Importante',
            style: _g(32, fw: FontWeight.w500, h: 1.3, c: _sageGreen)),
        const SizedBox(height: 16),
        Container(width: 48, height: 1, color: const Color(0x4DD4AF37)),
        const SizedBox(height: 32),
        ...items.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x33D4AF37), width: 0.5),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(e.$1, color: _sageGreen, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.$2, style: _m(13, fw: FontWeight.w500, ls: 2.6, c: _primary)),
                      const SizedBox(height: 4),
                      Text(e.$3, style: _m(16, h: 1.6)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
        const SizedBox(height: 48),
      ],
    );
  }

  // ─── RSVP ─────────────────────────────────────────────────────────────────
  Widget _rsvp() => Column(
        key: _rsvpKey,
        children: [
          const SizedBox(height: 48),
          SizedBox(width: 60, height: 24, child: CustomPaint(painter: _LeafPainter())),
          const SizedBox(height: 32),
          Text('Confirmar Asistencia',
              style: _g(32, fw: FontWeight.w500, h: 1.3, c: _primary)),
          const SizedBox(height: 8),
          Text('Por favor confirma antes del 15 de Septiembre',
              style: _m(16, h: 1.6, c: _textMuted)),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('NOMBRES DE LOS INVITADOS',
                style: _m(13, fw: FontWeight.w300, ls: 2.6, c: _onSurfaceVariant)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            maxLines: 4,
            style: _m(16, c: _textCharcoal),
            decoration: InputDecoration(
              hintText: 'Escribe tu nombre y el de tus acompañantes (uno por línea)',
              hintStyle: _m(16, c: _textMuted),
              filled: true,
              fillColor: _surfaceContainerLow,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _sageGreen, width: 1),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('¿ASISTIRÁS?',
                style: _m(13, fw: FontWeight.w300, ls: 2.6, c: _onSurfaceVariant)),
          ),
          const SizedBox(height: 16),
          _radio('yes', 'Acepto con gusto'),
          const SizedBox(height: 12),
          _radio('no', 'Lamentablemente no puedo'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send, size: 18),
              label: Text('ENVIAR CONFIRMACIÓN',
                  style: _m(13, fw: FontWeight.w300, ls: 2.6, c: _surfaceCream)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _sageGreen,
                foregroundColor: _surfaceCream,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                shape: const StadiumBorder(),
                elevation: 4,
              ),
            ),
          ),
        ],
      );

  Widget _radio(String val, String lbl) {
    final sel = _attendance == val;
    return GestureDetector(
      onTap: () => setState(() => _attendance = val),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: sel ? _sageGreen : _outlineVariant, width: 2),
              color: sel ? _sageGreen : Colors.transparent,
            ),
            child: sel
                ? const Center(child: Icon(Icons.circle, size: 8, color: Colors.white))
                : null,
          ),
          const SizedBox(width: 12),
          Text(lbl, style: _m(16, h: 1.6)),
        ]),
      ),
    );
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty || _attendance == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor completa todos los campos', style: _m(14, c: _surfaceCream)),
        backgroundColor: _sageGreen,
      ));
      return;
    }

    final attendanceValue =
        _attendance == 'yes' ? 'Acepto con gusto' : 'Lamentablemente no puedo';

    // Hidden iframe trick: submits to Google Forms without leaving the page
    final iframe = html.IFrameElement()
      ..name = 'hidden_iframe'
      ..style.display = 'none';
    html.document.body!.append(iframe);

    bool submitted = false;
    final isAccepted = _attendance == 'yes';
    iframe.onLoad.listen((_) {
      if (submitted) {
        iframe.remove();
        if (mounted) {
          if (isAccepted) {
            _showAcceptedDialog();
          } else {
            _showDeclinedDialog();
          }
        }
      }
    });

    final form = html.FormElement()
      ..action =
          'https://docs.google.com/forms/d/e/1FAIpQLSfDc3keNf9J2pcnAN8XTEhouRUdSCUtFYhBEcDymhS0XZZomA/formResponse'
      ..method = 'POST'
      ..target = 'hidden_iframe'
      ..style.display = 'none';

    form.append(html.TextAreaElement()
      ..name = 'entry.956041470'
      ..value = name);

    form.append(html.InputElement()
      ..type = 'hidden'
      ..name = 'entry.1624455386'
      ..value = attendanceValue);

    html.document.body!.append(form);
    submitted = true;
    form.submit();
    form.remove();
  }

  // ─── RSVP Confirmation Dialogs ────────────────────────────────────────────
  void _showAcceptedDialog() {
    const items = [
      (Icons.checkroom,      'CÓDIGO DE VESTIMENTA',        'Etiqueta formal. Agradecemos asistir con vestido largo o traje formal. Para conservar la elegancia de la ocasión, recomendamos evitar calzado deportivo.'),
      (Icons.person_add,     'INVITACIÓN PERSONAL',         'Hemos preparado esta celebración con mucho amor y cuidado. Por ello, agradecemos que nos acompañen únicamente las personas incluidas en esta invitación.'),
      (Icons.schedule,       'PUNTUALIDAD',                 'Nuestra ceremonia iniciará a la hora indicada. Les agradecemos llegar con anticipación para compartir juntos cada momento de esta ocasión tan especial.'),
      (Icons.phonelink_ring, 'CEREMONIA SIN DISTRACCIONES', 'Les invitamos a disfrutar plenamente de la ceremonia, manteniendo sus dispositivos móviles en silencio.'),
      (Icons.redeem,         'LLUVIA DE SOBRES',            'Su presencia será nuestro mejor regalo. Sin embargo, si desean bendecirnos con un obsequio, hemos elegido la modalidad de lluvia de sobres.'),
    ];
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: double.infinity,
            height: 520,
            child: Material(
              color: _surfaceCream,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('¡Gracias por confirmar!',
                              style: _g(24, fw: FontWeight.w500, c: _primary)),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close, color: _textMuted, size: 20),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 0.5, color: const Color(0x33D4AF37)),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estamos felices de que nos acompañes. Recuerda estos detalles importantes:',
                            style: _m(15, h: 1.6),
                          ),
                          const SizedBox(height: 20),
                          ...items.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(e.$1, color: _sageGreen, size: 20),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(e.$2,
                                          style: _m(11, fw: FontWeight.w500, ls: 2.2, c: _primary)),
                                      const SizedBox(height: 3),
                                      Text(e.$3, style: _m(12, h: 1.5, c: _textCharcoal)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: _surfaceContainerLow,
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _sageGreen,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Center(
                          child: Text('CERRAR',
                              style: _m(12, fw: FontWeight.w300, ls: 2.4, c: _surfaceCream)),
                        ),
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

  void _showDeclinedDialog() => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: _surfaceCream,
          title: Text('¡Gracias por informarnos!', style: _g(22, c: _primary)),
          content: Text('Lamentamos que no puedas acompañarnos.',
              style: _m(15, h: 1.6, c: _textCharcoal)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cerrar', style: _m(13, c: _sageGreen)),
            ),
          ],
        ),
      );

  // ─── Floating CTA ─────────────────────────────────────────────────────────
  Widget _floatingCTA() => Positioned(
        bottom: 16,
        left: 0,
        right: 0,
        child: Center(
          child: GestureDetector(
            onTap: () => _goto(_rsvpKey),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: _sageGreen,
                borderRadius: BorderRadius.circular(9999),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.event_available, color: _surfaceCream, size: 18),
                  const SizedBox(width: 8),
                  Text('CONFIRMAR ASISTENCIA',
                      style: _m(13, fw: FontWeight.w300, ls: 2.6, c: _surfaceCream)),
                ],
              ),
            ),
          ),
        ),
      );

  // ─── Bottom Nav ───────────────────────────────────────────────────────────
  Widget _bottomNav() => Container(
        color: _primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navI(Icons.home,          'INICIO',    () => _goto(_heroKey)),
              _navI(Icons.location_on,   'LUGAR',     () => _goto(_locKey)),
              _navI(Icons.photo_library, 'GALERÍA',   () => _goto(_galleryKey)),
              _navI(Icons.mail,          'CONFIRMAR', () => _goto(_rsvpKey)),
            ],
          ),
        ),
      );

  Widget _navI(IconData icon, String lbl, VoidCallback fn) => GestureDetector(
        onTap: fn,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xB3F4F1EA), size: 24),
              const SizedBox(height: 4),
              Text(lbl, style: _m(11, ls: 1.65, c: const Color(0xB3F4F1EA))),
            ],
          ),
        ),
      );

  // ─── Arch Image ───────────────────────────────────────────────────────────
  Widget _arch(String asset, {required double maxW}) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: _surfaceContainerHigh,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9999),
                    topRight: Radius.circular(9999),
                  ),
                  boxShadow: [
                    BoxShadow(color: Color(0x147A8B76), blurRadius: 40, offset: Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(9999),
                    topRight: Radius.circular(9999),
                  ),
                  child: Image.asset(asset, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      );
}

// ── Botanical Leaf Divider ────────────────────────────────────────────────────
class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = _accentGold
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(
      Path()
        ..moveTo(30, 12)
        ..cubicTo(25, 5, 15, 2, 5, 12)
        ..cubicTo(15, 22, 25, 19, 30, 12)
        ..close()
        ..moveTo(30, 12)
        ..cubicTo(35, 5, 45, 2, 55, 12)
        ..cubicTo(45, 22, 35, 19, 30, 12)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}