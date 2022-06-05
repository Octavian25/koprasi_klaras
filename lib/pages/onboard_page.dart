part of 'pages.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.green,
      body: Column(
        children: [
          SizedBox(
            height: 0.6.sh,
            child: Center(
              child: Image.asset(R.images.onboard, fit: BoxFit.cover),
            ),
          ),
          Container(
            height: 0.4.sh,
            width: 1.sw,
            color: R.colors.grenLight,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  'Klaras',
                  style: R.textStyle.bold24,
                ),
                Text(
                  'Cimanggung Hills',
                  style: R.textStyle.bold24,
                ),
                Text(
                  'Koperasi Bersama',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                30.verticalSpace,
                Center(
                  child: SizedBox(
                    width: 328.w,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: R.colors.greenDark, onPrimary: Colors.white),
                      onPressed: () {
                        Navigator.pushNamed(context, "/login", arguments: true);
                      },
                      child: const Text('Masuk'),
                    ),
                  ),
                ),
                20.verticalSpace
              ],
            ),
          )
        ],
      ),
    );
  }
}
