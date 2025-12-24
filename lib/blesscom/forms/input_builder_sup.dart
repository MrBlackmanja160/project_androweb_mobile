import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:kalbemd/Helper/global.dart';
import 'package:kalbemd/Helper/helper.dart';
import 'package:kalbemd/blesscom/forms/input_date.dart';
import 'package:kalbemd/blesscom/forms/input_dropdown.dart';
import 'package:kalbemd/blesscom/forms/input_photo.dart';
import 'package:kalbemd/blesscom/forms/input_photo_save.dart';
import 'package:kalbemd/blesscom/forms/input_photo_chooser.dart'; // NEW
import 'package:kalbemd/blesscom/forms/input_text.dart';
import 'package:kalbemd/blesscom/models/model_dropdown.dart';

class InputBuilder extends StatefulWidget {
  final List<Map<String, dynamic>> ieMaster;
  final Function(dynamic)? onSubmit;
  final String submitLabel;
  final String actionUrl;
  final bool enabled;
  final bool disabledButton;
  final bool isReadOnly;

  const InputBuilder({
    required this.ieMaster,
    this.onSubmit,
    this.submitLabel = "OK",
    this.actionUrl = "",
    this.enabled = true,
    this.disabledButton = false,
    this.isReadOnly = false,
    Key? key,
  }) : super(key: key);

  @override
  State<InputBuilder> createState() => _InputBuilderState();
}

class _InputBuilderState extends State<InputBuilder> {
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  final List<Widget> _widgets = [];

  // ============================================================
  // Helpers
  // ============================================================

  String? _validatorRequired(String? value) {
    if (value == null || value.isEmpty) return 'Harap diisi';
    return null;
  }

  bool _toBool(dynamic v, {bool defaultValue = false}) {
    if (v == null) return defaultValue;
    if (v is bool) return v;
    final s = v.toString().trim().toLowerCase();
    if (s.isEmpty) return defaultValue;
    return s == 'y' || s == 'yes' || s == 'true' || s == '1';
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

  void _setSimpleValue(String nm, String val) {
    final current = _values[nm];
    if (current is TextEditingController) {
      current.text = val;
    } else {
      _values[nm] = val;
    }
  }

  void _setDropdownTextController(String nm, String text) {
    final ctrlKey = '${nm}dropdown';
    final c = _values[ctrlKey];
    if (c is TextEditingController) {
      c.text = text;
    } else {
      _values[ctrlKey] = TextEditingController(text: text);
    }
  }

  // ====== support idsuplyer / nama_supplier / kode_supplier ======
  dynamic _getSupplierValue() {
    if (_values.containsKey('idsuplyer')) return _values['idsuplyer'];
    if (_values.containsKey('nama_supplier')) return _values['nama_supplier'];
    if (_values.containsKey('kode_supplier')) return _values['kode_supplier'];
    return null;
  }

  // ============================================================
  // MULTI ITEM HELPERS
  // - idbarang, idbarang_2, idbarang_3, ...
  // - harga, harga_2, harga_3, ...
  // - nama_produk, nama_produk_2, ...
  // ============================================================

  String _suffixFromNm(String nm) {
    final m = RegExp(r'_(\d+)$').firstMatch(nm);
    if (m == null) return '';
    return '_${m.group(1)}';
  }

  bool _isProductFieldNm(String nm) {
    // idbarang, idbarang_2, idproduk, idproduk_2, ...
    return RegExp(r'^(idbarang|idproduk)(_\d+)?$').hasMatch(nm);
  }

  bool _isHargaFieldNm(String nm) {
    return RegExp(r'^harga(_\d+)?$').hasMatch(nm);
  }

  bool _isSupplierFieldNm(String nm) {
    return nm == 'idsuplyer' || nm == 'nama_supplier' || nm == 'kode_supplier';
  }

  String _hargaNmFromProductNm(String prodNm) {
    // idbarang_2 -> harga_2, idbarang -> harga
    final suf = _suffixFromNm(prodNm);
    return 'harga$suf';
  }

  String _namaProdukHiddenNmFromProductNm(String prodNm) {
    final suf = _suffixFromNm(prodNm);
    return 'nama_produk$suf';
  }

  void _clearAllHargaFields() {
    final keys = _values.keys.toList();
    for (final k in keys) {
      final key = k.toString();
      if (_isHargaFieldNm(key)) {
        final v = _values[key];
        if (v is TextEditingController) {
          v.text = '';
        } else {
          _values[key] = TextEditingController(text: '');
        }
      }
    }
  }

  Future<void> _loadHargaForProductField(String prodFieldNm) async {
    final supVal = _getSupplierValue();
    final prodVal = _values[prodFieldNm];

    String prodId = '';
    String prodText = '';

    if (prodVal is ModelDropdown) {
      prodId = (prodVal.id ?? '').toString().trim();
      prodText = (prodVal.text ?? '').toString().trim();
    } else {
      prodText = (prodVal ?? '').toString().trim();
    }

    final nmHidden = _namaProdukHiddenNmFromProductNm(prodFieldNm);
    if ((prodText.isEmpty || prodText == '-') && _values.containsKey(nmHidden)) {
      final v = _values[nmHidden];
      final t = (v is TextEditingController) ? v.text : (v ?? '').toString();
      if (t.trim().isNotEmpty) prodText = t.trim();
    }

    if (prodId.isEmpty && prodText.isEmpty) return;

    try {
      final token = await Helper.getPrefs("token");
      final iduser = await Helper.getPrefs("iduser");

      final uri = Uri.parse(urlGetHargaJualSuplyer);

      final Map<String, String> body = {
        'token': token,
        'iduser': iduser,
        'idbarang': prodId,
        'field': prodFieldNm,
      };

      if (supVal is ModelDropdown) {
        final String sid = (supVal.id ?? '').toString().trim();
        if (sid.isNotEmpty) body['idsuplyer'] = sid;
      } else if (supVal != null) {
        final String s = supVal.toString().trim();
        if (s.isNotEmpty) body['nama_supplier'] = s;
      }

      if (prodText.isNotEmpty) body['nama_produk'] = prodText;
      if (prodId.isNotEmpty) body['idproduk'] = prodId;

      final resp = await http.post(uri, body: body);
      if (resp.statusCode != 200) return;

      final decoded = json.decode(resp.body);
      if (decoded is! Map) return;

      final sukses = decoded['Sukses'] == 'Y';
      if (!sukses) return;

      final String harga = (decoded['harga'] ?? '').toString();

      final hargaNm = _hargaNmFromProductNm(prodFieldNm);
      final vHarga = _values[hargaNm];
      if (vHarga is TextEditingController) {
        vHarga.text = harga;
      } else {
        _values[hargaNm] = TextEditingController(text: harga);
      }

      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _reloadHargaForAllSelectedProducts() async {
    final keys = _values.keys.map((e) => e.toString()).toList();
    for (final k in keys) {
      if (_isProductFieldNm(k)) {
        final v = _values[k];
        if (v is ModelDropdown) {
          final id = (v.id ?? '').toString().trim();
          if (id.isNotEmpty) {
            await _loadHargaForProductField(k);
          }
        }
      }
    }
  }

  void _ensureControllerFromInput(
    String nm,
    String value,
    Map<String, dynamic> input,
  ) {
    final ext = input['controller'];
    if (ext is TextEditingController) {
      if (_values[nm] is! TextEditingController) {
        _values[nm] = ext;
      }
      final c = _values[nm] as TextEditingController;
      if (c.text.isEmpty && value.isNotEmpty) c.text = value;
      return;
    }

    _values[nm] = _values[nm] is TextEditingController
        ? _values[nm]
        : TextEditingController(text: value);
  }

  // ============================================================
  // BUILD FORM
  // ============================================================

  void _buildForm() {
    _widgets.clear();

    for (final input in widget.ieMaster) {
      final String nm = (input['nm'] ?? '').toString();
      final String jns = (input['jns'] ?? '').toString();

      if (!_shouldShow(input)) continue;

      final String label = (input['label'] ?? '').toString();
      final String ajaxurl = (input['ajaxurl'] ?? '').toString();
      final String sourceKolom = (input['source_kolom'] ?? '').toString();
      final String customquery = (input['customquery'] ?? '').toString();
      final String idparent = (input['idparent'] ?? '').toString();
      final String idchild = (input['idchild'] ?? '').toString();
      final String required = (input['required'] ?? '').toString();

      final String itemReadOnlyStr =
          (input['readonly'] ?? '').toString().toLowerCase();
      final bool itemReadOnly =
          itemReadOnlyStr == 'y' || itemReadOnlyStr == 'true';
      final bool isReadOnly =
          widget.isReadOnly || !widget.enabled || itemReadOnly;

      final String value = (input['value'] ?? '').toString();
      final String valueText = (input['valuetext'] ?? '').toString();
      final String tempId = (input['temp_id'] ?? '').toString();

      // Default gallery = true (agar ada opsi kamera + galeri pada widget chooser)
      final dynamic galleryRaw =
          input.containsKey('gallery') ? input['gallery'] : 'Y';
      final bool isGallery = _toBool(galleryRaw, defaultValue: true);

      final int mininputchar =
          int.tryParse('${input['mininputchar'] ?? '0'}') ?? 0;

      final bool isRequired = required == 'Y';

      switch (jns) {
        case 'hidden':
          _values[nm] = _values.containsKey(nm) ? _values[nm] : value;
          break;

        case 'text':
          _ensureControllerFromInput(nm, value, input);
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

        case 'number':
          _ensureControllerFromInput(nm, value, input);
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

          final ddKey = '${nm}dropdown';
          _values[ddKey] = _values[ddKey] is TextEditingController
              ? _values[ddKey]
              : TextEditingController(text: valueText);

          _widgets.add(
            InputDropdown(
              value: _values[nm],
              nm: nm,
              controller: _values[ddKey],
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
              onChange: (val) async {
                String? copyTextTo;
                if (input['copyTextTo'] != null) {
                  copyTextTo = input['copyTextTo'].toString();
                } else if (_isProductFieldNm(nm)) {
                  copyTextTo = _namaProdukHiddenNmFromProductNm(nm);
                }

                setState(() {
                  _values[nm] = val;

                  if (val is ModelDropdown) {
                    _setDropdownTextController(nm, val.text ?? '');
                  }

                  if (copyTextTo != null &&
                      copyTextTo.isNotEmpty &&
                      val is ModelDropdown) {
                    _setSimpleValue(copyTextTo, (val.text ?? '').toString());
                  }

                  if (idchild.isNotEmpty) {
                    _values[idchild] = ModelDropdown(id: '', text: '');
                    final childCtrl = _values['${idchild}dropdown'];
                    if (childCtrl is TextEditingController) childCtrl.text = '';
                  }

                  _buildForm();
                });

                final cb = input['onChanged'];
                if (cb is Function) {
                  try {
                    if (val is ModelDropdown) {
                      cb(val.id, val.text);
                    } else {
                      cb(val, null);
                    }
                  } catch (_) {}
                }

                if (_isSupplierFieldNm(nm)) {
                  _clearAllHargaFields();
                  await _reloadHargaForAllSelectedProducts();
                } else if (_isProductFieldNm(nm)) {
                  await _loadHargaForProductField(nm);
                }
              },
            ),
          );
          break;

        case 'date':
          if (_values[nm] is! DateTime) _values[nm] = null;
          _widgets.add(
            InputDate(
              label: label,
              hint: label,
              validator: isRequired ? _validatorRequired : null,
              readOnly: isReadOnly,
              onChange: (val) {
                setState(() {
                  if (val != null) _values[nm] = val;
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
              initialValue: value,
              gallery: isGallery,
              onChange: (val) => setState(() {
                _values[nm] = val;
              }),
            ),
          );
          break;

        case 'croppiesave':
          _widgets.add(
            InputPhotoSave(
              label: label,
              enabled: !isReadOnly,
              initialValue: value,
              gallery: isGallery,
              temp_id: tempId,
              onChange: (val) => setState(() {
                _values[nm] = val;
              }),
            ),
          );
          break;

        case 'croppiesave_chooser':
          _widgets.add(
            InputPhotoSaveChooser(
              label: label,
              enabled: !isReadOnly,
              initialValue: value,
              gallery: isGallery,
              temp_id: tempId,
              onChange: (val) => setState(() {
                _values[nm] = val; // path lokal (kamera/galeri) atau string lama
              }),
            ),
          );
          break;

        default:
          _widgets.add(
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Not Implemented yet"),
            ),
          );
          break;
      }
    }
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  void _submit() {
    final st = _formKey.currentState;
    if (st != null && st.validate()) {
      sendHttpPostMultipart();
    }
  }

  Future<void> sendHttpPostMultipart() async {
    String responseBody = "";

    try {
      if (mounted) setState(() => _loading = true);

      final uri = Uri.parse(widget.actionUrl);
      final request = http.MultipartRequest("POST", uri);

      for (final input in widget.ieMaster) {
        final String nm = (input['nm'] ?? '').toString();
        final String jns = (input['jns'] ?? '').toString();
        final bool excludeIfHidden =
            (input['excludeIfHidden'] == true) ||
                ('${input['excludeIfHidden']}'.toLowerCase() == 'y');

        if (!_shouldShow(input) && excludeIfHidden) continue;

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
            } else {
              request.fields[nm] = '${value ?? ''}';
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
                request.files
                    .add(await http.MultipartFile.fromPath(nm, file.path));
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

          case 'croppiesave_chooser':
            if (value != null && value.toString().isNotEmpty) {
              final p = value.toString();
              final file = File(p);
              if (file.existsSync()) {
                request.files
                    .add(await http.MultipartFile.fromPath(nm, file.path));
              } else {
                request.fields[nm] = p;
              }
            }
            break;
        }
      }

      // ============================================================
      // DEBUG UPLOAD (implementasi sesuai instruksi)
      // ============================================================
      debugPrint("[UPLOAD] POST ${widget.actionUrl}");
      debugPrint("[UPLOAD] fields: ${request.fields}");
      for (final f in request.files) {
        debugPrint(
            "[UPLOAD] file field=${f.field} filename=${f.filename} length=${f.length}");
      }
      // ============================================================

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (!mounted) return;

      responseBody = response.body;

      debugPrint("[UPLOAD] status=${response.statusCode}");
      debugPrint("[UPLOAD] body=${response.body}");

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
    } catch (e) {
      if (mounted) {
        Helper.showAlert(
          context: context,
          message: "Error",
          details: e.toString(),
          type: AlertType.error,
        );
      }
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
  void didUpdateWidget(covariant InputBuilder oldWidget) {
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
