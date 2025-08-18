import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/widgets/boki_image_network.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class InputPhotoDua extends StatefulWidget {
  final String label;
  final String nm;
  final Function(String)? onChange;
  final double width;
  final double height;
  final String initialValue;
  final bool enabled;
  final bool gallery;

  const InputPhotoDua({
    this.label = "",
    this.nm = "",
    this.onChange,
    this.width = double.infinity,
    this.height = 200,
    this.initialValue = "",
    this.enabled = true,
    this.gallery = false,
    Key? key,
  }) : super(key: key);

  @override
  _InputPhotoDuaState createState() => _InputPhotoDuaState();
}

class _InputPhotoDuaState extends State<InputPhotoDua> {
  final ImagePicker _picker = ImagePicker();
  String _photoPath = "";
  XFile? _photo;
  var _image;
  var imgBytes;
  var watermarkedImgBytes;

  String splitByLength(String value, int length) {
    String pieces = "";

    for (int i = 0; i < value.length; i += length) {
      int offset = i + length;
      pieces +=
          value.substring(i, offset >= value.length ? value.length : offset) +
              "\n";
    }
    return pieces;
  }

  void _takePhoto() async {
    if (!widget.enabled) {
      return;
    }
    // Capture a photo
    _photo = await _picker.pickImage(
      source: (!widget.gallery) ? ImageSource.camera : ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 900,
      maxHeight: 900,
      imageQuality: 60,
    );

    // _photoPath = _photo != null ? _photo!.path : _photoPath;

    if (_photo != null) {
      _image = _photo;
      String _addressData = "";
      _addressData = await Helper.getPrefs("_addressData");
      String lat = await Helper.getPrefs("lat");
      String lng = await Helper.getPrefs("lng");
      String namadepan = await Helper.getPrefs("namadepan");
      String namabelakang = await Helper.getPrefs("namabelakang");
      String now = DateFormat('dd-MM-yyyy kk:mm').format(DateTime.now());

      String _addressDataSplit = splitByLength(_addressData, 80);
      _addressDataSplit += namadepan + " " + namabelakang + "\n";
      _addressDataSplit += lat + "," + lng + "\n";
      _addressDataSplit += now;

      _addressDataSplit = (!widget.gallery) ? _addressDataSplit : "";

      //split address data per 80 character enter .
      // var t = await _photo.readAsBytes();
      var t = await _photo!.readAsBytes();

      // prefs.setString("_addressData", _addressData);
      //imageCache.clear();
      //imageCache.clearLiveImages();

      imgBytes = Uint8List.fromList(t);
      watermarkedImgBytes = await ImageWatermark.addTextWatermark(
        imgBytes: imgBytes,
        watermarkText: _addressDataSplit,
        dstX: 10,
        dstY: 10,
        color: Colors.white,
      );

      Uint8List imageInUnit8List = watermarkedImgBytes;
      final tempDir = await getTemporaryDirectory();
      bool directoryExists =
          await Directory('${tempDir.path}/${widget.nm}.png').exists();
      bool fileExists = await File('${tempDir.path}/${widget.nm}.png').exists();

      if (directoryExists || fileExists) {
        // do stuff
        log("here iam kikuk kikuk");
        File fileX = File('${tempDir.path}/${widget.nm}.png');
        fileX.deleteSync(recursive: true);
      }
      File file = await File('${tempDir.path}/${widget.nm}.png').create();
      file.writeAsBytesSync(imageInUnit8List);

      _photoPath =
          watermarkedImgBytes != null ? file.path : watermarkedImgBytes;
    }

    // Trigger onchange
    if (mounted) {
      if (widget.onChange != null) {
        widget.onChange!(_photoPath);
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: widget.width,
      height: widget.height,
      child: InkWell(
        onTap: _takePhoto,
        child: Card(
          margin: EdgeInsets.zero,
          child: widget.initialValue.isNotEmpty && _photoPath.isEmpty
              // ? Image.network(
              //     widget.initialValue,
              //     fit: BoxFit.cover,
              //     errorBuilder: (context, error, stackTrace) => const SizedBox(
              //       height: 96,
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
                      key: UniqueKey(),
                    ),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
