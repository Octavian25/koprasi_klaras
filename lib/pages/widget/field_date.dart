part of '../pages.dart';

class CustomDateField extends StatefulWidget {
  String title;
  String hint;
  TextInputType keyboardType;
  TextEditingController controller;
  CustomDateField(
      {Key? key,
      required this.title,
      required this.hint,
      required this.keyboardType,
      required this.controller})
      : super(key: key);

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.text = selectedDate.toLocal().toString().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      width: 1.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: R.textStyle.semibold16.copyWith(fontSize: 13.sp),
          ),
          const Spacer(),
          Container(
            width: 1.sw,
            height: 40.h,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                10.horizontalSpace,
                Expanded(
                  child: TextFormField(
                      style: R.textStyle.regular13,
                      keyboardType: widget.keyboardType,
                      controller: widget.controller,
                      decoration: InputDecoration.collapsed(
                          hintText: widget.hint,
                          hintStyle: R.textStyle.regular13,
                          border: InputBorder.none)),
                ),
                IconButton(
                    splashRadius: 20,
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2021),
                          lastDate: DateTime(3000));
                      if (picked != null && picked != selectedDate) {
                        widget.controller.text =
                            picked.toLocal().toString().substring(0, 10);
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    icon: const Icon(Icons.date_range_rounded))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
