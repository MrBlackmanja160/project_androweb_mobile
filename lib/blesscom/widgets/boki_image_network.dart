import 'package:kalbemd/Theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class BokiImageNetwork extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const BokiImageNetwork({
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    Key? key,
  }) : super(key: key);

  @override
  _BokiImageNetworkState createState() => _BokiImageNetworkState();
}

class _BokiImageNetworkState extends State<BokiImageNetwork> {
  bool _loading = false;
  Image? _image;
  bool _error = false;
  String _errorMessage = "";

  void _init() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    // Reset
    _image = null;
    _error = false;
    _errorMessage = "";

    // Request
    try {
      http.Response response = await http.get(Uri.parse(widget.url));
      // 200 = success
      if (response.statusCode == 200) {
        _image = Image.memory(
          response.bodyBytes,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      }
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_image == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(8),
        child: Center(
          child: _error
              ? Text(
                  _errorMessage,
                  overflow: TextOverflow.ellipsis,
                  style: textStyleSmall.copyWith(
                      color: Theme.of(context).colorScheme.error),
                )
              : const Icon(
                  FontAwesomeIcons.unlink,
                  size: 14,
                ),
        ),
      );
    }

    return _image!;
  }
}
