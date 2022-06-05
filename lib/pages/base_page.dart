part of 'pages.dart';

class BasePage extends StatefulWidget {
  Widget child;
  BasePage({Key? key, required this.child}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    bool isloading = Provider.of<LoadingProvider>(context).isLoading;
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          if (isloading)
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black38,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.dotsTriangle(
                          color: R.colors.grenLight, size: 50),
                      20.verticalSpace,
                      const Align(
                        alignment: Alignment.center,
                        child: Text('Mohon Tunggu..',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
