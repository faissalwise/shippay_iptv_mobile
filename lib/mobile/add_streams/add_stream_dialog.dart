import 'package:fastotv_common/colors.dart';
import 'package:fastotvlite/base/add_streams/add_stream_dialog.dart';
import 'package:fastotvlite/localization/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilePickerDialog extends BaseFilePickerDialog {
  final PickStreamFrom source;

  FilePickerDialog(this.source) : super(source);

  @override
  _FilePickerDialogState createState() => _FilePickerDialogState();
}

class _FilePickerDialogState extends BaseFilePickerDialogState {
  @override
  Widget textField() {
    OutlineInputBorder border() {
      return OutlineInputBorder(borderSide: BorderSide(color: CustomColor().themeBrightnessColor(context), width: 1));
    }

    return new TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            focusedBorder: border(),
            border: border(),
            hintText: translate(TR_INPUT_LINK),
            errorText: validator ? null : translate(TR_INCORRECT_LINK),
            contentPadding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0)),
        onFieldSubmitted: (String value) => validateLink());
  }
}
