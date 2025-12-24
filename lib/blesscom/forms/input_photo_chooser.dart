import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputPhotoSaveChooser extends StatefulWidget {
  final String label;
  final bool enabled;

  /// URL/filename lama (untuk edit)
  final String initialValue;

  /// jika true, tampilkan opsi galeri
  final bool gallery;

  /// temp id (opsional)
  final String temp_id;

  /// callback value: path lokal (kamera/galeri) ATAU string lama
  final ValueChanged<String>? onChange;

  const InputPhotoSaveChooser({
    Key? key,
    required this.label,
    required this.enabled,
    required this.initialValue,
    required this.gallery,
    required this.temp_id,
    required this.onChange,
  }) : super(key: key);

  @override
  State<InputPhotoSaveChooser> createState() => _InputPhotoSaveChooserState();
}

class _InputPhotoSaveChooserState extends State<InputPhotoSaveChooser> {
  final ImagePicker _picker = ImagePicker();
  String _current = "";

  @override
  void initState() {
    super.initState();
    _current = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant InputPhotoSaveChooser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && !_isLocalPath(_current)) {
      _current = widget.initialValue;
    }
  }

  bool _isLocalPath(String v) {
    if (v.isEmpty) return false;
    return v.startsWith('/') || v.contains(r':\');
  }

  bool _isNetworkUrl(String v) {
    return v.startsWith('http://') || v.startsWith('https://');
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final XFile? xf = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (xf == null) return;

      setState(() => _current = xf.path);
      widget.onChange?.call(_current);
    } catch (_) {}
  }

  Future<void> _openChooser() async {
    if (!widget.enabled) return;

    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Ambil Gambar (Kamera)"),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pick(ImageSource.camera);
                },
              ),
              if (widget.gallery)
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Pilih dari Galeri"),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pick(ImageSource.gallery);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _preview() {
    if (_current.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, size: 34, color: Colors.white70),
          const SizedBox(height: 10),
          Text(widget.label, style: const TextStyle(color: Colors.white70)),
        ],
      );
    }

    if (_isLocalPath(_current)) {
      final f = File(_current);
      if (f.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            f,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }
    }

    if (_isNetworkUrl(_current)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          _current,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Center(
      child: Text(
        _current,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? _openChooser : null,
      child: Container(
        width: double.infinity,
        height: 170,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _preview()),
            Positioned(
              right: 8,
              top: 8,
              child: Opacity(
                opacity: widget.enabled ? 1 : 0.4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text("Ubah", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
