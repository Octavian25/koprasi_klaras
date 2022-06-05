part of 'pages.dart';

class AddBalance extends StatefulWidget {
  const AddBalance({Key? key}) : super(key: key);

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: R.colors.grenLight,
        title: Text(
          "Tambah Saldo",
          style: R.textStyle.semibold16,
        ),
        leading: IconButton(
          splashRadius: 18.w,
          onPressed: () {
            Navigator.pushNamed(context, "/home_admin");
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
              FutureBuilder<List<String>>(
                  future: PaymentService().streamAllPayment(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return CustomDropdown(
                          list: snapshot.data,
                          validationMessage: "Mohon Pilih Metode Pembayaran",
                          onSelected: (String data) {
                            setState(() {
                              metodeSelected = data;
                            });
                          },
                          value: metodeSelected,
                          title: "Metode Pembayaran");
                    } else {
                      return const Text('Loading');
                    }
                  }),
              10.verticalSpace,
              CustomDateField(
                  title: "Tanggal",
                  hint: "Pilih Tanggal",
                  keyboardType: TextInputType.number,
                  controller: tanggalController),
              10.verticalSpace,
              FutureBuilder<List<String>>(
                  future: UserService().streamAllUser(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return CustomDropdown(
                          list: snapshot.data,
                          validationMessage: "Mohon Pilih Metode Pembayaran",
                          onSelected: (String data) {
                            setState(() {
                              nameSelected = data;
                            });
                          },
                          value: metodeSelected,
                          title: "Nama Anggota");
                    } else {
                      return const Text('Loading');
                    }
                  }),
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
                    } else if (nameSelected == "") {
                      R.helper.showToast(context, "Nama Anggota Belum Dipilih");
                    } else if (metodeSelected == "") {
                      R.helper.showToast(
                          context, "Metode Pembayaran Belum Dipilih");
                    } else {
                      Provider.of<LoadingProvider>(context, listen: false)
                          .startLoading();
                      if (await TransactionService().addTransaction(
                          nameSelected,
                          int.parse(nominalController.text),
                          metodeSelected,
                          tanggalController.text)) {
                        R.helper.showToast(context,
                            "Tambah Saldo Berhasil, Silahkan Verifikasi Data");
                        nominalController.clear();
                        tanggalController.clear();
                        // loginProvider.updateBalance();
                        setState(() {
                          metodeSelected = "";
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
