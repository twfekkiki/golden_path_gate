import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';

class HSCodeListField extends FormField<List<String>> {
  HSCodeListField({
    super.key,
    List<String>? initialValue,
    super.onSaved,
    super.validator,
    bool autovalidate = false,
    Function(List<String>?)? onChanged
  }) : super(
    initialValue: initialValue ?? [],
    builder: (FormFieldState<List<String>> state) {
      return HSCodeList(
        state: state,
        initialValue: initialValue,
        onChanged: onChanged,
      );
    },
  );
}


class HSCodeList extends StatefulWidget {
  final FormFieldState<List<String>> state;
  final List<String>? initialValue;
  final Function(List<String>?)? onChanged;

  const HSCodeList({super.key, required this.state, this.initialValue,this.onChanged});

  @override
  State<HSCodeList> createState() => _HSCodeListState();
}

class _HSCodeListState extends State<HSCodeList> {

  int count = 1;

  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    for(int i = 0 ; i<10 ; i++){
      _controllers.add(TextEditingController(
        text: i < (widget.initialValue?.length ?? 0)
            ? widget.initialValue![i]
            : "",
      ));
    }
    count = widget.initialValue?.length ?? 1;
    super.initState();
  }


  void _updateFormFieldState() {
    final HSCodes = <String>[];

    for (int i=0 ; i<count;i++) {
      final row = _controllers[i];
      final value = row.text;

      // if (value.isEmpty) {
      //   widget.state.didChange(null); // Mark invalid
      //   return;
      // }
      HSCodes.add(value.trim());
    }
    widget.state.didChange(HSCodes);
    if(widget.onChanged != null){
      widget.onChanged!(HSCodes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          count + 1, (index){
            if(index == count){
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: (){
                        count++;
                        setState(() {

                        });
                      },
                      icon: Icon(
                        Icons.add_circle,
                        size: 25,
                        color: AppColors.secondary,
                      )
                  )
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index == count -1 ? 0 : 12
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controllers[index],
                      cursorWidth: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                      onChanged: (value){
                        _updateFormFieldState();
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kCornerRadius),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey.shade200
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kCornerRadius),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey.shade200
                            )
                        ),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kCornerRadius),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey.shade200
                            )
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kCornerRadius),
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey.shade200
                            )
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        count--;
                        _controllers[index].dispose();
                        _controllers.removeAt(index);
                        _controllers.add(TextEditingController());
                        setState(() {

                        });
                      },
                      icon: Icon(
                        Icons.remove_circle,
                        size: 25,
                        color: Colors.red,
                      )
                  )
                ],
              ),
            );
      }
      ),
    );
  }
}
