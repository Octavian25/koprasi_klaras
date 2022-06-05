part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController blokController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSaveInfo = false;
  @override
  void initState() {
    super.initState();
    checkSavedData();
  }

  @override
  void dispose() {
    super.dispose();
    namaController.dispose();
    blokController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> checkSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? email = preferences.getString(LoginProvider.EMAILKEY);
    String? password = preferences.getString(LoginProvider.PASSKEY);
    if (email != null && password != null) {
      if (await Provider.of<LoginProvider>(context, listen: false)
          .login(email, password, true)) {
        if (Provider.of<LoginProvider>(context, listen: false)
                .userModel!
                .role ==
            "ADMIN") {
          Navigator.pushNamed(context, "/home_admin");
        } else {
          Navigator.pushNamed(context, "/home");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    RegisterProvider registerProvider = Provider.of<RegisterProvider>(context);
    bool? isLogin = ModalRoute.of(context)?.settings.arguments as bool;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: R.colors.grenLight,
        title: Text(
          isLogin ? "Login" : "Register",
          style: R.textStyle.semibold16,
        ),
        automaticallyImplyLeading: false,
        leading: isLogin
            ? null
            : IconButton(
                splashRadius: 18.w,
                onPressed: () {
                  if (!isLogin) {
                    Navigator.pushNamed(context, "/login", arguments: true);
                  } else {
                    Navigator.pushNamed(context, "/");
                  }
                },
                icon: const Icon(Icons.chevron_left, color: Colors.black),
              ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            if (!isLogin)
              CustomField(
                  title: "Nama",
                  hint: "Nama",
                  keyboardType: TextInputType.emailAddress,
                  controller: namaController),
            10.verticalSpace,
            if (!isLogin)
              CustomField(
                  title: "Blok",
                  hint: "Blok",
                  keyboardType: TextInputType.emailAddress,
                  controller: blokController),
            10.verticalSpace,
            CustomField(
                title: "Email",
                hint: "Email",
                keyboardType: TextInputType.emailAddress,
                controller: emailController),
            10.verticalSpace,
            CustomField(
                title: "Password",
                hint: "Password",
                isPassword: true,
                keyboardType: TextInputType.text,
                controller: passwordController),
            if (isLogin)
              Row(
                children: [
                  Transform.scale(
                    scale: 1,
                    child: Checkbox(
                        checkColor: R.colors.greenDark,
                        activeColor: R.colors.grenLight,
                        shape: CircleBorder(),
                        value: isSaveInfo,
                        onChanged: (data) {
                          setState(() {
                            isSaveInfo = data!;
                          });
                        }),
                  ),
                  Text('Simpan Data'),
                ],
              ),
            10.verticalSpace,
            SizedBox(
              height: 40.h,
              width: 1.sw,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: R.colors.greenDark,
                    onPrimary: R.colors.grenLight),
                onPressed: () async {
                  if (!isLogin) {
                    Provider.of<LoadingProvider>(context, listen: false)
                        .startLoading();
                    if (await registerProvider.register(
                        emailController.text,
                        passwordController.text,
                        namaController.text,
                        blokController.text)) {
                      Navigator.pop(context);
                      R.helper.showToast(context,
                          registerProvider.registerFeedbackModel!.feedback);
                      Provider.of<LoadingProvider>(context, listen: false)
                          .endLoading();
                    } else {
                      Provider.of<LoadingProvider>(context, listen: false)
                          .endLoading();
                      R.helper.showToast(context,
                          registerProvider.registerFeedbackModel!.feedback);
                    }
                  } else {
                    if (await loginProvider.login(emailController.text,
                        passwordController.text, isSaveInfo)) {
                      if (loginProvider.userModel!.role == "ADMIN") {
                        Navigator.pushNamed(context, "/home_admin");
                      } else {
                        Navigator.pushNamed(context, "/home");
                      }
                    } else {
                      if (loginProvider.code == "user-not-found") {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pushNamed(context, "/login",
                                              arguments: false);
                                        },
                                        child: const Text("Daftarkan Akun Ini"))
                                  ],
                                  title: const Text("User Belum Terdaftar"),
                                  content: SizedBox(
                                    height: 50.h,
                                    child:
                                        Text("Email : ${emailController.text}"),
                                  ),
                                ));
                      }
                      R.helper.showToast(context,
                          "Login Gagal, Periksa Koneksi Internet Anda");
                    }
                  }
                },
                child: Text(
                  isLogin ? 'Masuk' : "Daftar",
                  style: R.textStyle.regular12.copyWith(color: Colors.white),
                ),
              ),
            ),
            10.verticalSpace,
            isLogin
                ? SizedBox(
                    height: 40.h,
                    width: 1.sw,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: R.colors.green,
                          onPrimary: R.colors.greenDark),
                      onPressed: () async {
                        Navigator.pushNamed(context, "/login",
                            arguments: false);
                      },
                      child: Text(
                        'Daftar',
                        style: R.textStyle.regular12
                            .copyWith(color: R.colors.greenDark),
                      ),
                    ),
                  )
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}
