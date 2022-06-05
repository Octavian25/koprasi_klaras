part of '../pages.dart';

class CustomDropdown extends StatefulWidget {
  List<String>? list;
  String validationMessage;
  Function(String) onSelected;
  String title;
  String? value;
  CustomDropdown(
      {Key? key,
      required this.list,
      required this.validationMessage,
      required this.onSelected,
      this.value,
      required this.title})
      : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedValue = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 77.h,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: R.textStyle.semibold16.copyWith(fontSize: 13.sp),
          ),
          const Spacer(),
          DropdownButtonFormField2<String?>(
            decoration: InputDecoration(
              //Add isDense true and zero Padding.
              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              //Add more decoration as you want here
              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
            ),
            isExpanded: true,
            hint: Text(
              widget.title,
              style: const TextStyle(fontSize: 14),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 30,
            buttonHeight: 50,
            buttonPadding: const EdgeInsets.only(left: 20, right: 10),
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            items: widget.list
                    ?.map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList() ??
                [],
            validator: (value) {
              if (value == null) {
                return widget.validationMessage;
              }
              return null;
            },
            onChanged: (value) {
              selectedValue = value.toString();
              widget.onSelected(value.toString());
            },
            onSaved: (value) {
              selectedValue = value.toString();
              widget.onSelected(value.toString());
            },
          ),
        ],
      ),
    );
  }
}
