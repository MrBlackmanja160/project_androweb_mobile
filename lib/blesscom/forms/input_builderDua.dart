import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_photo_dua.dart';
import 'package:kalbemd/blesscom/forms/input_radio_fotodua.dart';
import 'package:kalbemd/blesscom/models/model_dropdown.dart';
import 'package:kalbemd/blesscom/forms/input_date.dart';
import 'package:kalbemd/blesscom/forms/input_dropdown.dart';
import 'package:kalbemd/blesscom/forms/input_photo.dart';
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InputBuilderDua extends StatefulWidget {
  final List<Map<String, String>> ieMaster;
  final Function(dynamic)? onSubmit;
  final String submitLabel;
  final String actionUrl;
  final bool enabled;
  final bool disabledButton;

  const InputBuilderDua({
    required this.ieMaster,
    this.onSubmit,
    this.submitLabel = "OK",
    this.actionUrl = "",
    this.enabled = true,
    this.disabledButton = false,
    Key? key,
  }) : super(key: key);

  @override
  _InputBuilderDuaState createState() => _InputBuilderDuaState();
}

class _InputBuilderDuaState extends State<InputBuilderDua> {
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _values = {};
  final List<Widget> _widgets = [];

  void _buildForm() {
    // Clear all
    _widgets.clear();
    _values.clear();

    // Build widgets
    widget.ieMaster.asMap().forEach((index, input) {
      //perulangan widget disini!!
      // Get properties
      String nm = input["nm"] ?? "";
      String jns = input["jns"] ?? "";
      String label = input["label"] ?? "";
      String sourceKolom = input["source_kolom"] ?? "";
      String ajaxurl = input["ajaxurl"] ?? "";
      String customquery = input["customquery"] ?? "";
      String idparent = input["idparent"] ?? "";
      String idchild = input["idchild"] ?? "";
      String required = input["required"] ?? "";
      String readonly = input["readonly"] ?? "";
      String value = input["value"] ?? "";
      String valueText = input["valuetext"] ?? "";
      int mininputchar = int.parse(input["mininputchar"] ?? "0");
      String gallery = input["gallery"] ?? "T";

      // Flags
      bool isRequired = required == "Y";
      bool isReadOnly = readonly == "Y" || !widget.enabled;
      bool isGallery = gallery == "Y";

      // Create text input
      switch (jns) {
        case "hidden":
          _values[nm] = value;
          break;
        case "text":
          _values[nm] = TextEditingController(text: value);
          _widgets.add(
            InputText(
              controller: _values[nm],
              label: label,
              validator: isRequired ? _validatorRequired : null,
              readOnly: isReadOnly,
              enabled: !isReadOnly,
            ),
          );
          break;
        case "number":
          _values[nm] = TextEditingController(text: value);
          _widgets.add(
            InputText(
              controller: _values[nm],
              label: label,
              validator: isRequired ? _validatorRequired : null,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              readOnly: isReadOnly,
              enabled: !isReadOnly,
            ),
          );

          break;
        case "selcustomqueryAjax":
          _values[nm] = ModelDropdown(id: value, text: valueText);
          _values["${nm}dropdown"] = TextEditingController(text: valueText);

          _widgets.add(InputDropdown(
            value: _values[nm],
              nm:nm,
            controller: _values["${nm}dropdown"],
            ajaxUrl: ajaxurl,
            sourceKolom: sourceKolom,
            customQuery: customquery,
            label: label,
            hint: label,
            hintSearch: "Pencarian",
             idparent:idparent,
            minInputChar: mininputchar,
            validator: isRequired ? _validatorRequired : null,
            onChange: (val) => setState(() {
              _values[nm] = val;
              if (idchild != "") {
                log("masuk sini");
                _values["${idchild}dropdown"].text = "";
                // _values[idchild] = ModelDropdown(id: "", text: "");
              }
              //simpan di session saja
            }),
            readOnly: isReadOnly,
          ));
          break;
        case "date":
          _values[nm] = null;
          _widgets.add(InputDate(
            label: label,
            hint: label,
            value: (value.isEmpty) ? DateTime.now() : DateTime.parse(value),
            validator: isRequired ? _validatorRequired : null,
            onChange: (val) => setState(() {
              if (val != null) {
                _values[nm] = val;
              }
            }),
            readOnly: isReadOnly,
          ));
          break;
        case "croppie":
          _values[nm] = null;
          _widgets.add(InputPhoto(
            label: label,
            onChange: (val) => setState(() {
              //val adalah photo_path
              _values[nm] = val;
            }),
            enabled: !isReadOnly,
            initialValue: value,
            gallery: isGallery,
          ));
          break;

        case "croppiedua":
          _values[nm] = null;
          _widgets.add(InputPhotoDua(
            label: label,
            nm: nm,
            onChange: (val) => setState(() {
              //val adalah photo_path
              _values[nm] = val;
            }),
            enabled: !isReadOnly,
            initialValue: value,
            gallery: isGallery,
          ));
          break;

        case "radiodua":
          _values[nm] = null;
          
          _widgets.add(InputRadioFotoDua(
            label: label,
            nm: nm,
            enabled: !isReadOnly,
            initialValue: value,
            gallery: isGallery,
            onChange: (val) => setState(() {
              _values[nm] = val;
            }),
          ));
          break;

        default:
          _widgets.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("'$jns' Not Implemented yet"),
            ),
          );
          break;
      }
    });
  }

  String? _validatorRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harap diisi';
    }
    return null;
  }

  void _submit() {
    // Validate form
    if (_formKey.currentState!.validate()) {
      // Send data
      sendHttpPostMultipart();
    }
  }

  void sendHttpPostMultipart() async {
    String responseBody = "";
    try {
      if (mounted) {
        setState(() {
          _loading = true;
        });
      }

      final Uri uri = Uri.parse(widget.actionUrl);

      // Create request
      var request = http.MultipartRequest("POST", uri);

      // Add POST data
      widget.ieMaster.asMap().forEach(
        (index, input) async {
          // Get properties
          String nm = input["nm"] ?? "";
          String jns = input["jns"] ?? "";
          var value = _values[nm];

          switch (jns) {
            case "hidden":
              request.fields[nm] = value;
              break;
            case "text":
            case "number":
              request.fields[nm] = value.text;
              break;
            case "selcustomqueryAjax":
              request.fields[nm] = value.id;
              break;
            case "date":
              request.fields[nm] = DateFormat("yyyy-MM-dd").format((value == null) ? DateTime.now() : value);
              break;
            case "croppie":
              if (value != null && value != "") {
                request.files.add(
                  await http.MultipartFile.fromPath(nm, value),
                );
              }
              break;
            case "croppiedua":
              if (value != null && value != "") {
                request.files.add(
                  await http.MultipartFile.fromPath(nm, value),
                );
              }
              break;
            case "radiodua":
              if (value != null && value != "") {
                request.files.add(
                  await http.MultipartFile.fromPath(nm, value),
                );
              }
              break;
          }
        },
      );

      log("-------------");
      log("Sending data to : " + widget.actionUrl);
      log("-------------");
      log(request.fields.toString());

      if (widget.actionUrl.isEmpty) {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
        return;
      }

      // Response
      var response = await http.Response.fromStream(await request.send());
      responseBody = response.body;
      log("-------------");
      log("Response from : " + widget.actionUrl);
      log("-------------");
      log(response.body);

      // Fire on submit event
      widget.onSubmit?.call(jsonDecode(response.body));
    } on SocketException {
      log("No internet connection");
      if (mounted) {
        Helper.showSnackBar(context, "No internet connection");
      }
    } on HttpException {
      log("Couldn't connect to server");
      if (mounted) {
        Helper.showSnackBar(context, "Couldn't connect to server");
      }
    } on FormatException {
      log("Bad response format");
      if (mounted) {
        Helper.showAlert(
          context: context,
          message: "Bad response format",
          details: responseBody,
          type: AlertType.error,
        );
      }
    } on http.ClientException {
      log("Client error");
      if (mounted) {
        Helper.showSnackBar(context, "Client error");
      }
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
    _buildForm();
  }

  // @override
  // void didUpdateWidget(covariant InputBuilderDua oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _buildForm();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            children: _widgets,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: !_loading && !widget.disabledButton ? _submit : null,
              child: !_loading
                  ? Text(widget.submitLabel)
                  : const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
