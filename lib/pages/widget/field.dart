part of '../pages.dart';

class CustomField extends StatelessWidget {
  String title;
  String hint;
  TextInputType keyboardType;
  TextEditingController controller;
  bool isPassword = false;
  CustomField(
      {Key? key,
      required this.title,
      required this.hint,
      required this.keyboardType,
      this.isPassword = false,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.h,
      width: 1.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
                      keyboardType: keyboardType,
                      controller: controller,
                      obscureText: isPassword,
                      decoration: InputDecoration.collapsed(
                          hintText: hint,
                          hintStyle: R.textStyle.regular13,
                          border: InputBorder.none)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
