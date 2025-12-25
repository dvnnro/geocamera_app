import 'dart:io'; // Untuk mengakses File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker
import 'package:geolocator/geolocator.dart'; // Import Geolocator

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GeoCameraPage(),
    );
  }
}

class GeoCameraPage extends StatefulWidget {
  const GeoCameraPage({super.key});

  @override
  State<GeoCameraPage> createState() => _GeoCameraPageState();
}

class _GeoCameraPageState extends State<GeoCameraPage> {
  // Variabel untuk menyimpan file foto
  File? _image;

  // Variabel untuk menyimpan teks lokasi
  String _locationMessage = "Lokasi belum diambil";

  // Variabel loading agar UI tidak freeze
  bool _isLoading = false;

  // Instance ImagePicker
  final ImagePicker _picker = ImagePicker();

  // FUNGSI 1: Meminta Izin & Ambil Lokasi
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah GPS aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi (GPS) nonaktif.');
    }

    // Cek izin aplikasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak permanen.');
    }

    // Jika semua aman, ambil posisi saat ini
    return await Geolocator.getCurrentPosition();
  }

  // FUNGSI UTAMA: Ambil Foto lalu Ambil Lokasi
  Future<void> _takePictureAndLocation() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });

    try {
      // 1. Buka Kamera
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50, // Kompresi agar tidak terlalu besar
      );

      // Jika user menekan tombol 'Back' (batal foto)
      if (photo == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 2. Ambil Lokasi (Hanya jika foto berhasil diambil)
      Position position = await _determinePosition();

      // 3. Update State (Tampilan)
      setState(() {
        _image = File(photo.path); // Konversi XFile ke File
        _locationMessage =
            "Latitude: ${position.latitude}\nLongitude: ${position.longitude}";
        _isLoading = false; // Selesai loading
      });
    } catch (e) {
      // Tangani error (misal: GPS mati, atau Izin ditolak)
      setState(() {
        _isLoading = false;
        _locationMessage = "Gagal mengambil data: $e";
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoCamera Praktikum'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AREA FOTO
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    _image == null
                        ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text("Belum ada foto"),
                          ],
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
              ),

              const SizedBox(height: 20),

              // AREA LOKASI
              Text(
                _locationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // TOMBOL AKSI
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                    onPressed: _takePictureAndLocation,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Ambil Foto & Lokasi'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
