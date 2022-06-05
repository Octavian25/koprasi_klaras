part of 'pages.dart';

class WithdrawBalance extends StatefulWidget {
  const WithdrawBalance({Key? key}) : super(key: key);

  @override
  State<WithdrawBalance> createState() => _WithdrawBalanceState();
}

class _WithdrawBalanceState extends State<WithdrawBalance> {
  String selectedValue = "";
  TextEditingController nominalController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  String nameSelected = "";
  String metodeSelected = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nominalController.dispose();
    tanggalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: R.colors.grenLight,
        title: Text(
          "Ambil Saldo",
          style: R.textStyle.semibold16,
        ),
        leading: IconButton(
          splashRadius: 18.w,
          onPressed: () {
            Navigator.pushNamed(context, "/home");
          },
          icon: const Icon(Icons.chevron_left, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomField(
                  title: "Nominal",
                  hint: "Masukan Nominal",
                  keyboardType: TextInputType.number,
                  controller: nominalController),
              10.verticalSpace,
              CustomDateField(
                  title: "Tanggal",
                  hint: "Pilih Tanggal",
                  keyboardType: TextInputType.number,
                  controller: tanggalController),
              20.verticalSpace,
              SizedBox(
                height: 45.h,
                width: 1.sw,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: R.colors.greenDark,
                      onPrimary: R.colors.grenLight),
                  onPressed: () async {
                    if (nominalController.text.isEmpty) {
                      R.helper.showToast(context, "Nominal Belum Diisi");
                    } else if (tanggalController.text.isEmpty) {
                      R.helper.showToast(context, "Tanggal Belum Diisi");
                    } else if (loginProvider.balance! <
                        int.parse(nominalController.text)) {
                      R.helper.showToast(
                          context, "Ambil Saldo Melebihi Saldo Tersedia");
                    } else {
                      Provider.of<LoadingProvider>(context, listen: false)
                          .startLoading();
                      if (await TransactionService().withdrawTransaction(
                          "${loginProvider.userModel!.name} / ${loginProvider.userModel!.blokRumah}",
                          loginProvider.user?.uid ?? "-",
                          int.parse(nominalController.text),
                          tanggalController.text)) {
                        R.helper.showToast(context,
                            "Ambil Saldo Berhasil, Silahkan Tunggu Konfirmasi Pengurus");
                        nominalController.clear();
                        tanggalController.clear();
                        setState(() {
                          nameSelected = "";
                        });
                        Provider.of<LoadingProvider>(context, listen: false)
                            .endLoading();
                      } else {
                        Provider.of<LoadingProvider>(context, listen: false)
                            .endLoading();
                        R.helper.showToast(context, "Gagal Menyimpan data");
                      }
                    }
                  },
                  child: Text(
                    'Simpan',
                    style: R.textStyle.regular12.copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
