import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import '../domain/sensor_data.dart';
import '../../../core/localization/app_localizations.dart';

enum MonitorStatus { disconnected, connecting, connected, error }

class Esp32MonitorScreen extends StatefulWidget {
  final String? initialUrl;
  const Esp32MonitorScreen({super.key, this.initialUrl});

  @override
  State<Esp32MonitorScreen> createState() => _Esp32MonitorScreenState();
}

class _Esp32MonitorScreenState extends State<Esp32MonitorScreen> {
  final TextEditingController _urlController = TextEditingController();
  SensorData? _data;
  MonitorStatus _status = MonitorStatus.disconnected;
  String _errorMessage = '';
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initialUrl != null && widget.initialUrl!.isNotEmpty) {
      _urlController.text = widget.initialUrl!;
      _startPolling(_urlController.text);
    }
  }

  @override
  void dispose() {
    _stopPolling();
    _urlController.dispose();
    super.dispose();
  }

  String _normalizeAddress(String input) {
    String address = input.trim();
    if (address.isEmpty) return '';
    if (!address.startsWith('http://') && !address.startsWith('https://')) {
      address = 'http://$address';
    }
    return address;
  }

  void _startPolling(String inputUrl) {
    _stopPolling();
    final baseUrl = _normalizeAddress(inputUrl);
    if (baseUrl.isEmpty) return;

    setState(() {
      _status = MonitorStatus.connecting;
      _errorMessage = '';
    });

    _fetchData(baseUrl);
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _fetchData(baseUrl);
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _fetchData(String baseUrl) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/data'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          _data = SensorData.fromJson(jsonData);
          _status = MonitorStatus.connected;
          _errorMessage = '';
        });
      } else {
        setState(() {
          _status = MonitorStatus.error;
          _errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _status = MonitorStatus.error;
        _errorMessage = 'Connection failed: $e';
      });
    }
  }

  Future<void> _scanQr() async {
    final scannedUrl = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerPage()),
    );

    if (scannedUrl != null && scannedUrl.isNotEmpty) {
      _urlController.text = scannedUrl;
      _startPolling(scannedUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: const Color(0xff0a0e21),
      appBar: AppBar(
        title: Text(s.esp32Monitor, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputCard(s),
            const SizedBox(height: 24),
            _buildStatusCard(s),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildValueCard(s.temperature, '${_data?.temperature?.toStringAsFixed(1) ?? '--'} °C', Icons.thermostat_rounded, Colors.orangeAccent)),
                const SizedBox(width: 16),
                Expanded(child: _buildValueCard(s.humidity, '${_data?.humidity?.toStringAsFixed(1) ?? '--'} %', Icons.water_drop_rounded, Colors.blueAccent)),
              ],
            ),
            const SizedBox(height: 32),
            if (_status == MonitorStatus.connected || _status == MonitorStatus.connecting || _status == MonitorStatus.error)
              ElevatedButton(
                onPressed: () {
                  _stopPolling();
                  setState(() => _status = MonitorStatus.disconnected);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  foregroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(s.disconnect, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(S s) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.esp32Address, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(
            controller: _urlController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. 172.18.100.4',
              hintStyle: const TextStyle(color: Colors.white24),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _startPolling(_urlController.text),
                  icon: const Icon(Icons.sensors_rounded),
                  label: Text(s.connect),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _scanQr,
                icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.orangeAccent),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(S s) {
    Color statusColor;
    String statusText;
    switch (_status) {
      case MonitorStatus.connected:
        statusColor = Colors.greenAccent;
        statusText = s.connected;
        break;
      case MonitorStatus.connecting:
        statusColor = Colors.orangeAccent;
        statusText = s.connecting;
        break;
      case MonitorStatus.error:
        statusColor = Colors.redAccent;
        statusText = 'Error';
        break;
      case MonitorStatus.disconnected:
      default:
        statusColor = Colors.white24;
        statusText = s.disconnected;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          if (_errorMessage.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(_errorMessage, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
          if (_status == MonitorStatus.connected) ...[
            const SizedBox(height: 4),
            Text(_normalizeAddress(_urlController.text), style: const TextStyle(color: Colors.white38, fontSize: 11)),
          ]
        ],
      ),
    );
  }

  Widget _buildValueCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  bool _popped = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    // Check if we are on a simulator
    final bool isSimulator = Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(s.scanQrCode, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_popped) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _popped = true;
                  Navigator.of(context).pop(barcode.rawValue);
                  break;
                }
              }
            },
          ),
          // Helper overlay for users to know it might not work on simulator
          if (const bool.fromEnvironment('dart.vm.product') == false)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black54,
                child: Text(
                  s.simulatorScannerNote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
