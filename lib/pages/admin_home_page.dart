part of 'pages.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Stream<QuerySnapshot> streamHistory = TransactionService().streamHistory();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInit();
  }

  Future<void> checkInit() async {
    LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: false);
    if (await NotificationService().getInit()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Koperasi Klaras'),
                content: Text(
                    'Koperasi Klaras Memerlukan Akses Notifikasi Untuk Mempercepat Pertukaran Informasi',
                    style: R.textStyle.regular12),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await NotificationService().createSubcribedToFirebase(
                          loginProvider.userModel!.id,
                          loginProvider.userModel!);
                      await NotificationService().setInit();
                      Navigator.pop(context);
                    },
                    child: const Text('Izinkan'),
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: R.colors.grenLight,
        title: Text(
          "Hi, ${loginProvider.userModel!.name} - ${loginProvider.userModel!.blokRumah}",
          style: R.textStyle.semibold16,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          splashRadius: 18.w,
          onPressed: () {
            _key.currentState!.openDrawer();
          },
          icon: const Icon(Icons.sort_rounded, color: Colors.black),
        ),
      ),
      drawerEnableOpenDragGesture: false,
      drawerDragStartBehavior: DragStartBehavior.start,
      drawerScrimColor: R.colors.greenDark.withOpacity(0.5),
      drawer: drawerWidget(loginProvider),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(loginProvider),
                81.h.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text('History Transaksi',
                      style: R.textStyle.bold12.copyWith(fontSize: 15.sp)),
                ),
                15.h.verticalSpace,
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: streamHistory,
                      builder: (_, snapshot) {
                        List<AddTransactionModel> listTransaction = [];
                        if (snapshot.hasData) {
                          listTransaction = snapshot.data!.docs
                              .map((e) => AddTransactionModel.fromJson(
                                  e.data() as Map<String, dynamic>))
                              .toList();
                          return ListView.separated(
                              itemBuilder: (context, index) =>
                                  itemHistoryTransaksi(
                                      listTransaction[index], index),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: listTransaction.length);
                        } else {
                          return const Text('Loading');
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
            actionButton(loginProvider)
          ],
        ),
      ),
    );
  }

  Drawer drawerWidget(LoginProvider loginProvider) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Center(
                child: CircleAvatar(
                  backgroundColor: R.colors.grenLight,
                  backgroundImage: const AssetImage("assets/Success.png"),
                  radius: 50.w,
                ),
              ),
              10.verticalSpace,
              Center(
                  child: Text(
                'Octavian',
                style: R.textStyle.semibold16,
              )),
              Center(
                  child: Text(
                'Anggota',
                style: R.textStyle.regular12,
              )),
              10.verticalSpace,
              const Divider(),
              10.verticalSpace,
              Text(
                'Menu',
                style: R.textStyle.bold12.copyWith(fontSize: 16.sp),
              ),
              10.verticalSpace,
              ListTile(
                onTap: () async {
                  if (await Provider.of<BalanceProvider>(context, listen: false)
                      .getMonthlyFee()) {
                    _key.currentState!.closeDrawer();
                    R.helper.showToast(
                        context, "Pengambilan Iurang Bulanan Selesai");
                  } else {
                    _key.currentState!.closeDrawer();
                    R.helper.showToast(context,
                        "Pengambilan Iuran Gagal, Silahkan Ulangi Lagi Nanti");
                  }
                },
                title: Text(
                  'Tagih Iuran Bulanan',
                  style: R.textStyle.regular12,
                ),
                subtitle: Text('Ambil Iuran Bulanan Dari Semua Anggota',
                    style:
                        R.textStyle.regular10.copyWith(color: Colors.black38),
                    maxLines: 1),
              ),
              ListTile(
                onTap: () async {
                  await loginProvider.logout();
                  Navigator.pushNamed(context, "/login", arguments: true);
                },
                title: Text(
                  'Logout Account',
                  style: R.textStyle.regular12,
                ),
                subtitle: Text('Keluarkan Akun dari perangkat',
                    style:
                        R.textStyle.regular10.copyWith(color: Colors.black38),
                    maxLines: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container header(LoginProvider loginProvider) {
    return Container(
      height: 130.h,
      width: 1.sw,
      color: R.colors.grenLight,
      child: Column(
        children: [
          5.h.verticalSpace,
          Text('Total Uang Anda Saat Ini', style: R.textStyle.regular12),
          5.h.verticalSpace,
          Divider(endIndent: 30.w, indent: 30.w),
          StreamBuilder<DocumentSnapshot>(
              stream: BalanceService().streamGlobalBalance(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                      NumberFormat.currency(
                              decimalDigits: 0, symbol: "Rp. ", locale: "id")
                          .format(snapshot.data!.get("balance")),
                      style: R.textStyle.extrabold32);
                } else {
                  return const Text('Loading');
                }
              }),
        ],
      ),
    );
  }

  SizedBox itemHistoryTransaksi(AddTransactionModel data, int Index) {
    BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: false);
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return SizedBox(
      height: 50.h,
      child: Slidable(
        key: ValueKey(Index),
        enabled: data.status != "VALID",
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                Provider.of<LoadingProvider>(context, listen: false)
                    .startLoading();
                if (await balanceProvider.adminAction(
                    data, loginProvider.userModel!)) {}
                Provider.of<LoadingProvider>(context, listen: false)
                    .endLoading();
              },
              backgroundColor: const Color(0xFF398928),
              foregroundColor: Colors.white,
              icon: Icons.check,
              spacing: 10,
            ),
            SlidableAction(
              onPressed: (context) async {
                Provider.of<LoadingProvider>(context, listen: false)
                    .startLoading();
                await NotificationService().sendNotitication(
                    name: data.nama.split("/")[0].trim(),
                    nominal: data.nominal,
                    title: "Pengajuan Anda Ditolak",
                    type: "Mengajukan");
                Provider.of<LoadingProvider>(context, listen: false)
                    .endLoading();
              },
              backgroundColor: const Color(0xFF7F0D30),
              foregroundColor: Colors.white,
              icon: Icons.close,
              spacing: 10,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 42.h,
              width: 42.h,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: data.type == "ADD"
                  ? Icon(Icons.call_received_outlined, size: 16.sp)
                  : Icon(Icons.call_made_outlined, size: 16.sp),
            ),
            15.w.horizontalSpace,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    data.type == "ADD"
                        ? 'Setoran Uang'
                        : data.type == "MONTHLY FEE"
                            ? "Iuran Bulanan"
                            : 'Ambil Uang',
                    style: R.textStyle.bold12),
                Text('${data.nama} / ${data.input_date}',
                    style: R.textStyle.regular12),
              ],
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    NumberFormat.currency(symbol: "Rp. ", decimalDigits: 0)
                        .format(data.nominal),
                    style: R.textStyle.bold12.copyWith(
                        color: data.status == "NOT VALID"
                            ? Colors.red
                            : Colors.black)),
                Text(data.status == "NOT VALID" ? "BELUM DIVALIDASI" : "VALID",
                    style: R.textStyle.regular12.copyWith(
                        fontSize: 8.sp,
                        color: data.status == "NOT VALID"
                            ? Colors.red
                            : R.colors.greenDark))
              ],
            ),
            10.horizontalSpace
          ],
        ),
      ),
    );
  }

  Container actionButton(LoginProvider loginProvider) {
    return Container(
      height: 87.h,
      width: 1.sw,
      margin: EdgeInsets.only(top: 0.16.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          loginProvider.userModel!.role == "ADMIN"
              ? ActionButtonHomeWidget(
                  icon: const Icon(Icons.call_made_outlined),
                  onClick: () {
                    Navigator.pushNamed(context, "/add_balance");
                  },
                  title: "Tambah Saldo")
              : const SizedBox(),
          loginProvider.userModel!.role == "ADMIN"
              ? ActionButtonHomeWidget(
                  icon: const Icon(Icons.history_rounded),
                  onClick: () {},
                  title: "History")
              : const SizedBox(),
        ],
      ),
    );
  }
}
