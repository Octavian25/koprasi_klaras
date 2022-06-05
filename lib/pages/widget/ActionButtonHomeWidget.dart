part of '../pages.dart';

class ActionButtonHomeWidget extends StatelessWidget {
  Function() onClick;
  Icon icon;
  String title;
  ActionButtonHomeWidget(
      {Key? key,
      required this.onClick,
      required this.icon,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      height: 90.h,
      child: Column(
        children: [
          Material(
            elevation: 2,
            shape: const CircleBorder(side: BorderSide.none),
            child: InkWell(
              onTap: onClick,
              customBorder: const CircleBorder(side: BorderSide.none),
              child: Ink(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: SizedBox(
                  height: 55.h,
                  width: 55.h,
                  child: icon,
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(title,
              style: R.textStyle.regular12, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
