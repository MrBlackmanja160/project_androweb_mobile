import 'dart:io';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:kalbemd/blesscom/widgets/boki_image_network.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class InputPhotoKeterangan extends StatefulWidget {
  final String label;
  final String idjenisphoto;
  final Function(String, String)? onChange;
  final double width;
  final double height;
  final String initialValue;
  final bool enabled;

  const InputPhotoKeterangan({
    this.label = "",
    this.idjenisphoto = "",
    this.onChange,
    this.width = double.infinity,
    this.height = 200,
    this.initialValue = "",
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  @override
  _InputPhotoKeteranganState createState() => _InputPhotoKeteranganState();
}

class _InputPhotoKeteranganState extends State<InputPhotoKeterangan> {
  final ImagePicker _picker = ImagePicker();
  String _photoPath = "";
  XFile? _photo;

  void _takePhoto() async {
    if (!widget.enabled) {
      return;
    }
    // Capture a photo
    _photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 60,
    );

    _photoPath = _photo != null ? _photo!.path : _photoPath;

    // Trigger onchange
    if (widget.onChange != null) {
      widget.onChange!(_photoPath, widget.idjenisphoto);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("ini inisial "+widget.initialValue);
    // print("ini photopath "+_photoPath);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: widget.width,
      height: widget.height,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              widget.label,
              style: textStyleBold,
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: _takePhoto,
                child: widget.initialValue.isNotEmpty && _photoPath.isEmpty
                    // ? Image.network(
                    //     widget.initialValue,
                    //     fit: BoxFit.cover,
                    //     errorBuilder: (context, error, stackTrace) =>
                    //         const SizedBox(
                    //       height: 128,
                    //       child: Icon(
                    //         FontAwesomeIcons.unlink,
                    //       ),
                    //     ),
                    //   )
                    ? BokiImageNetwork(url: widget.initialValue)
                    : _photoPath.isEmpty
                        ? Column(
                            children: [
                              const Spacer(),
                              const Icon(FontAwesomeIcons.camera),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.label,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Spacer(),
                            ],
                          )
                        : Image.file(
                            File(_photoPath),
                            fit: BoxFit.cover,
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
