import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';


class ShipmentDimensionsField extends FormField<List<ShipmentDimension>> {
  ShipmentDimensionsField({
    super.key,
    List<ShipmentDimension>? initialValue,
    super.onSaved,
    super.validator,
    Function(List<ShipmentDimension>?)? onChanged
  }) : super(
         initialValue: initialValue ?? [],
         builder: (FormFieldState<List<ShipmentDimension>> state) {
           return DimensionsList(state: state, initialValue: initialValue,onChanged: onChanged,);
         },
       );

  static String? validateDimensions(List<ShipmentDimension>? value) {
    if (value != null) {
      for (var row in value) {
        if (row.count == null &&
            row.l == null &&
            row.w == null &&
            row.h == null) {
          continue;
        }
        if (row.count == null ||
            row.l == null ||
            row.w == null ||
            row.h == null) {
          return 'Please fill the missing fields';
        }
      }
    }
    return null;
  }
}

class DimensionsList extends StatefulWidget {
  final FormFieldState<List<ShipmentDimension>> state;
  final List<ShipmentDimension>? initialValue;
  final Function(List<ShipmentDimension>?)? onChanged;

  const DimensionsList({super.key, required this.state, this.initialValue,this.onChanged});

  @override
  State<DimensionsList> createState() => _DimensionsListState();
}

class _DimensionsListState extends State<DimensionsList> {
  int count = 1;

  final List<List<TextEditingController>> _controllers = [];

  final List<ShipmentDimension> dimensions = [];

  @override
  void initState() {
    for (int i = 0; i < 10; i++) {
      _controllers.add([
        TextEditingController(
          text:
              i < (widget.initialValue?.length ?? 0)
                  ? widget.initialValue![i].count.toString()
                  : "",
        ),
        TextEditingController(
          text:
              i < (widget.initialValue?.length ?? 0)
                  ? widget.initialValue![i].l.toString()
                  : "",
        ),
        TextEditingController(
          text:
              i < (widget.initialValue?.length ?? 0)
                  ? widget.initialValue![i].w.toString()
                  : "",
        ),
        TextEditingController(
          text:
              i < (widget.initialValue?.length ?? 0)
                  ? widget.initialValue![i].h.toString()
                  : "",
        ),
      ]);
    }
    count = widget.initialValue?.length ?? 1;
    super.initState();
  }

  void _updateFormFieldState() {
    final dimensions = <ShipmentDimension>[];

    for (int i = 0; i < count; i++) {
      var row = _controllers[i];
      final count = int.tryParse(row[0].text);
      final l = double.tryParse(row[1].text);
      final w = double.tryParse(row[2].text);
      final h = double.tryParse(row[3].text);
      // if (l == null || w == null || h == null || count == null) {
      //   widget.state.didChange(null); // Mark invalid
      //   return;
      // }
      dimensions.add(ShipmentDimension(l: l, w: w, h: h, count: count));
    }
    widget.state.didChange(dimensions);
    if(widget.onChanged != null){
      widget.onChanged!(dimensions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).trans("pCount"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).trans("lengthShort"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).trans("widthShort"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).trans("heightShort"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 41),
          ],
        ),
        const SizedBox(height: 2),
        Column(
          children: List.generate(count + 1, (index) {
            if (index == count) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      count++;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.add_circle,
                      size: 25,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.only(bottom: index == count - 1 ? 0 : 12),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: getTextFieldWidget(_controllers[index][0]),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: getTextFieldWidget(_controllers[index][1]),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: getTextFieldWidget(_controllers[index][2]),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: getTextFieldWidget(_controllers[index][3]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      count--;
                      for (var con in _controllers[index]) {
                        con.dispose();
                      }
                      _controllers.removeAt(index);
                      _controllers.add([
                        TextEditingController(),
                        TextEditingController(),
                        TextEditingController(),
                        TextEditingController(),
                      ]);
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      size: 25,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        if (widget.state.hasError)
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.state.errorText ?? '',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
      ],
    );
  }

  getTextFieldWidget(TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorWidth: 2,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      onChanged: (value) {
        _updateFormFieldState();
      },
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade200),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade200),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(width: 1, color: Colors.grey.shade200),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var cl in _controllers) {
      for (var controller in cl) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}
