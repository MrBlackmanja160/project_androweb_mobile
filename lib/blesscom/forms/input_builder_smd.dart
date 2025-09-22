import 'dart:convert';
import 'dart:io';

import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_photo_save.dart';
import 'package:kalbemd/blesscom/models/model_dropdown.dart';
import 'package:kalbemd/blesscom/forms/input_date.dart';
import 'package:kalbemd/blesscom/forms/input_dropdown.dart';
import 'package:kalbemd/blesscom/forms/input_photo.dart';
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:kalbemd/blesscom/forms/input_textdua.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InputBuilderSMD extends StatefulWidget {
  final List<Map<String, dynamic>> ieMaster;
  final Function(dynamic)? onSubmit;
  final String submitLabel;
  final String actionUrl;
  final bool enabled;
  final bool disabledButton;

  const InputBuilderSMD({
    required this.ieMaster,
    this.onSubmit,
    this.submitLabel = "OK",
    this.actionUrl = "",
    this.enabled = true,
    this.disabledButton = false,
    Key? key,
  }) : super(key: key);

  @override
  _InputBuilderSMDState createState() => _InputBuilderSMDState();
}

class _InputBuilderSMDState extends State<InputBuilderSMD> {
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _values = {};
  final List<Widget> _widgets = [];

  // simpan data persist khusus field rak ndb
  final Map<String, dynamic> _persistedValues = {};

  String? _validatorRequired(String? value) {
    if (value == null || value.isEmpty) return 'Harap diisi';
    return null;
  }

  dynamic _readForCompare(String key) {
    var k = key;
    var wantText = false;
    if (k.endsWith('#text')) {
      wantText = true;
      k = k.substring(0, k.length - 5);
    }
    final v = _values[k];
    if (v is TextEditingController) return v.text;
    if (v is ModelDropdown) return wantText ? v.text : v.id;
    if (v is DateTime) return DateFormat('yyyy-MM-dd').format(v);
    return v;
  }

  bool _shouldShow(Map<String, dynamic> input) {
    final cond = input['showif'];
    if (cond == null || cond is! Map) return true;
    for (final entry in cond.entries) {
      final key = entry.key.toString();
      final expected = entry.value;
      final actual = _readForCompare(key);
      final act = '${actual ?? ''}';
      if (expected is List) {
        final list = expected.map((e) => '${e ?? ''}').toList();
        if (!list.contains(act)) return false;
      } else {
        if (act != '${expected ?? ''}') return false;
      }
    }
    return true;
  }

  void _persistIfNeeded(String nm, dynamic val) {
    if (nm == "foto_rak_ndb" || nm == "keterangan_rak_ndb") {
      _persistedValues[nm] = val;
    }
  }

  void _buildForm() {
    _widgets.clear();

    for (final input in widget.ieMaster) {
      final String nm = (input['nm'] ?? '') as String;
      final String jns = (input['jns'] ?? '') as String;
      final String label = (input['label'] ?? '') as String;
      final String ajaxurl = (input['ajaxurl'] ?? '') as String;
      final String sourceKolom = (input['source_kolom'] ?? '') as String;
      final String customquery = (input['customquery'] ?? '') as String;
      final String idparent = (input['idparent'] ?? '') as String;
      final String idchild = (input['idchild'] ?? '') as String;
      final String required = (input['required'] ?? '') as String;
      final String readonly = (input['readonly'] ?? '') as String;
      final String value = (input['value'] ?? '')?.toString() ?? '';
      final String valueText = (input['valuetext'] ?? '')?.toString() ?? '';
      final String tempId = (input['temp_id'] ?? '') as String;
      final String gallery = (input['gallery'] ?? 'T') as String;
      final int mininputchar =
            int.tryParse('${input['mininputchar'] ?? '0'}') ?? 0;

      final bool isRequired = required == 'Y';
      final bool isReadOnly = readonly == 'Y' || !widget.enabled;
      final bool isGallery = gallery == 'Y';

      // kondisi hidden, tetap simpan valuenya
      if (!_shouldShow(input)) {
        if (_persistedValues.containsKey(nm)) {
          _values[nm] = _persistedValues[nm];
        } else {
          _values[nm] = value;
        }
        continue;
      }

      switch (jns) {
        case 'hidden':
          _values[nm] = _values.containsKey(nm) ? _values[nm] : value;
          break;

        case 'text':
          _values[nm] = _values[nm] is TextEditingController
              ? _values[nm]
              : TextEditingController(
                  text: _persistedValues[nm] ?? value,
                );

          if (nm == "keterangan_rak_ndb") {
            _widgets.add(
              InputTextDua(
                controller: _values[nm],
                label: label,
                validator: isRequired ? _validatorRequired : null,
                readOnly: isReadOnly,
                enabled: !isReadOnly,
                onChanged: (val) => _persistIfNeeded(nm, val),
              ),
            );
          } else {
            _widgets.add(
              InputText(
                controller: _values[nm],
                label: label,
                validator: isRequired ? _validatorRequired : null,
                readOnly: isReadOnly,
                enabled: !isReadOnly,
              ),
            );
          }
          break;

        case 'number':
          _values[nm] = _values[nm] is TextEditingController
              ? _values[nm]
              : TextEditingController(text: value);
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

        case 'selcustomqueryAjax':
          _values[nm] = (_values[nm] is ModelDropdown)
              ? _values[nm]
              : ModelDropdown(id: value, text: valueText);
          _values['${nm}dropdown'] =
              _values['${nm}dropdown'] is TextEditingController
                  ? _values['${nm}dropdown']
                  : TextEditingController(text: valueText);

          _widgets.add(
            InputDropdown(
              value: _values[nm],
              nm: nm,
              controller: _values['${nm}dropdown'],
              ajaxUrl: ajaxurl,
              sourceKolom: sourceKolom,
              customQuery: customquery,
              label: label,
              hint: label,
              hintSearch: 'Pencarian',
              idparent: idparent,
              minInputChar: mininputchar,
              validator: isRequired ? _validatorRequired : null,
              readOnly: isReadOnly,
              onChange: (val) {
                setState(() {
                  _values[nm] = val;
                  if (idchild.isNotEmpty) {
                    _values[idchild] = ModelDropdown(id: '', text: '');
                    _values['${idchild}dropdown']?.text = '';
                  }
                  _buildForm();
                });
              },
            ),
          );
          break;

        case 'date':
          if (_values[nm] is! DateTime && _values[nm] == null) {
            _values[nm] = null;
          }
          _widgets.add(
            InputDate(
              label: label,
              hint: label,
              validator: isRequired ? _validatorRequired : null,
              readOnly: isReadOnly,
              onChange: (val) {
                setState(() {
                  if (val != null) _values[nm] = val;
                  _persistIfNeeded(nm, val);
                  _buildForm();
                });
              },
            ),
          );
          break;

        case 'croppie':
          _widgets.add(
            InputPhoto(
              label: label,
              enabled: !isReadOnly,
              initialValue: _persistedValues[nm] ?? _values[nm] ?? value,
              gallery: isGallery,
              onChange: (val) => setState(() {
                _values[nm] = val;
                _persistIfNeeded(nm, val);
              }),
            ),
          );
          break;

        case 'croppiesave':
          _widgets.add(
            InputPhotoSave(
              label: label,
              enabled: !isReadOnly,
              initialValue: (_persistedValues[nm] != null &&
                      _persistedValues[nm].toString().isNotEmpty)
                  ? _persistedValues[nm]
                  : (_values[nm] != null && _values[nm].toString().isNotEmpty)
                      ? _values[nm]
                      : value,
              gallery: isGallery,
              temp_id: tempId,
              onChange: (val) => setState(() {
                _values[nm] = val;
                _persistIfNeeded(nm, val);
              }),
            ),
          );
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
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Validasi kondisi Rak ada NDB terpenuhi
    final jenisNdsText = _readForCompare("idjenisnds#text");
    final fotoRakNdb = _values["foto_rak_ndb"]?.toString() ?? "";
    final ketRakNdb = _values["keterangan_rak_ndb"] is TextEditingController
        ? _values["keterangan_rak_ndb"].text
        : (_values["keterangan_rak_ndb"]?.toString() ?? "");
    final isEdit = widget.ieMaster.any(
      (m) => m['nm'] == 'action' && (m['value']?.toString().toLowerCase() == 'edit'),
    );

    if (jenisNdsText == "Ada Rak NDB") {
      if (fotoRakNdb.isEmpty && !isEdit) {
        Helper.showAlert(
          context: context,
          message: "Foto Rak NDB wajib diisi",
          type: AlertType.error,
        );
        return;
      }
      if (ketRakNdb.isEmpty && !isEdit) {
        Helper.showAlert(
          context: context,
          message: "Keterangan Rak NDB wajib diisi",
          type: AlertType.error,
        );
        return;
      }
    }

    sendHttpPostMultipart();
  }

  Future<void> sendHttpPostMultipart() async {
    String responseBody = "";
    try {
      if (mounted) setState(() => _loading = true);

      final uri = Uri.parse(widget.actionUrl);
      final request = http.MultipartRequest("POST", uri);

      for (final input in widget.ieMaster) {
        final String nm = (input['nm'] ?? '') as String;
        final String jns = (input['jns'] ?? '') as String;

        final dynamic value = _values[nm];

        switch (jns) {
          case 'hidden':
            request.fields[nm] = '${value ?? ''}';
            break;

          case 'text':
          case 'number':
            request.fields[nm] =
                (value is TextEditingController) ? value.text : '${value ?? ''}';
            break;

          case 'selcustomqueryAjax':
            if (value is ModelDropdown) {
              request.fields[nm] = value.id ?? '';
            }
            break;

          case 'date':
            if (value is DateTime) {
              request.fields[nm] = DateFormat('yyyy-MM-dd').format(value);
            } else {
              request.fields[nm] = '';
            }
            break;

          case 'croppie':
            if (value != null && value.toString().isNotEmpty) {
              final file = File(value.toString());
              if (file.existsSync()) {
                request.files.add(
                  await http.MultipartFile.fromPath(nm, file.path),
                );
              } else {
                request.fields[nm] = value.toString();
              }
            }
            break;

          case 'croppiesave':
            if (value != null && value.toString().isNotEmpty) {
              request.fields[nm] = value.toString();
            }
            break;
        }
      }

      final response = await http.Response.fromStream(await request.send());
      if (!mounted) return;
      responseBody = response.body;
      widget.onSubmit?.call(jsonDecode(response.body));
    } on SocketException {
      if (mounted) Helper.showSnackBar(context, "No internet connection");
    } on HttpException {
      if (mounted) Helper.showSnackBar(context, "Couldn't connect to server");
    } on FormatException {
      if (mounted) {
        Helper.showAlert(
          context: context,
          message: "Bad response format",
          details: responseBody,
          type: AlertType.error,
        );
      }
    } on http.ClientException {
      if (mounted) Helper.showSnackBar(context, "Client error");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _buildForm();
  }

  @override
  void didUpdateWidget(covariant InputBuilderSMD oldWidget) {
    super.didUpdateWidget(oldWidget);
    _buildForm();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(children: _widgets),
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
