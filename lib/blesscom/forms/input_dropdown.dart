import 'dart:async';
import 'dart:developer';

import 'package:kalbemd/blesscom/models/model_dropdown.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/Theme/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class InputDropdown extends StatefulWidget {
  final ModelDropdown value;
  final String nm;
  final TextEditingController? controller;
  final String ajaxUrl;
  final String sourceKolom;
  final String customQuery;
  final String label;
  final String hint;
  final String hintSearch;
  final String idparent;
  final int minInputChar;
  final bool readOnly;
  final Function(ModelDropdown)? onChange;
  final FormFieldValidator<String>? validator;

  const InputDropdown({
    Key? key,
    required this.value,
    required this.nm,
    this.controller,
    required this.ajaxUrl,
    this.sourceKolom = "a.nama",
    this.customQuery = "",
    this.label = "",
    this.hint = "",
    this.hintSearch = "",
    this.idparent = "",
    this.minInputChar = 0,
    this.onChange,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _InputDropdownState createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: widget.validator,
        // controller: TextEditingController(text: widget.value.text),
        controller: widget
            .controller, // TextEditingController(text: widget.value.text),
        showCursor: false,
        readOnly: true,
        enabled: !widget.readOnly,
        onTap: () {
          if (!widget.readOnly) {
            showSearchDialog(context);
          }
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          label: Text(widget.label),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Icon(
              FontAwesomeIcons.sortDown,
              size: 18,
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
  }

  void showSearchDialog(
    BuildContext context, {
    void Function(dynamic)? onChange,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return InputDropdownModal(
              parent: widget,
            );
          });
        });
    setState(() {});
  }
}

class InputDropdownModal extends StatefulWidget {
  final InputDropdown parent;

  const InputDropdownModal({
    Key? key,
    required this.parent,
  }) : super(key: key);

  @override
  _InputDropdownModalState createState() => _InputDropdownModalState();
}

class _InputDropdownModalState extends State<InputDropdownModal> {
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  bool _isLoading = false;
  final List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _onSearchChanged("");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          widget.parent.label,
          style: textStyleMediumBold,
        ),
      ),
      content: Column(
        children: [
          TextField(
            onChanged: (String val) {
              _onSearchChanged(val);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                FontAwesomeIcons.search,
                size: 18,
              ),
              hintText: widget.parent.hintSearch,
            ),
          ),
          const Divider(),
          _isLoading
              ? const LinearProgressIndicator()
              : Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (ModelDropdown _item in _items)
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                style: const ButtonStyle(
                                    alignment: Alignment.centerLeft),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  widget.parent.value.id = _item.id;
                                  widget.parent.value.text = _item.text;
                                  // widget.parent.controller.text = _item.text;
                                  widget.parent.controller?.text = _item.text ?? '';
                                  if (widget.parent.onChange != null) {
                                    widget.parent.onChange!(_item);
                                    log("set session ${widget.parent.nm}, nilainya ${_item.id}");
                                    await prefs.setString(
                                      widget.parent.nm,
                                      _item.id,
                                    );
                                  }
                                  Navigator.pop(context, _item);
                                },
                                child: Text(
                                  _item.text,
                                  style: textStyleBold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
          const Divider(),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Tutup",
                style: textStyleBold,
              ))
        ],
      ),
    );
  }

  void _onSearchChanged(String val) {
    // When user stopped typing, start sending search request
    debouncer.run(() {
      _fetchData(val);
    });
  }

  void _fetchData(String search) async {
    if (search.length < widget.parent.minInputChar) {
      return;
    }

    // Get token and iduser
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? iduser = prefs.getString("iduser");

    // Build url
    String url = widget.parent.ajaxUrl;

    // Send request
    Helper.sendHttpPostOld(
      url,
      postData: {
        "search": search,
        "source_kolom": widget.parent.sourceKolom,
        "token": token,
        "iduser": iduser,
        "query": widget.parent.customQuery,
        "idparent": widget.parent.idparent,
        "valueparent": prefs.getString(widget.parent.idparent) ?? ""
      },
      onStart: () {
        // Loading start
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      onFinish: (response) {
        // Map to list
        _items.clear();
        for (var result in response) {
          _items.add(ModelDropdown.fromJson(result));
        }

        // Loading end
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}

// Class for delay before sending search request
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
