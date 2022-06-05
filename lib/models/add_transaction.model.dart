class AddTransactionModel {
  String nama;
  String payment_method;
  String id;
  int nominal;
  String type;
  String input_by;
  String input_date;
  String status;
  String valid_by;
  String valid_date;
  String bukti_pembayaran;
  String kode_transaksi;

  AddTransactionModel(
      {required this.nama,
      required this.nominal,
      required this.id,
      required this.type,
      required this.payment_method,
      required this.input_date,
      required this.input_by,
      required this.status,
      required this.valid_by,
      required this.valid_date,
      required this.kode_transaksi,
      required this.bukti_pembayaran});

  AddTransactionModel copyWith({
    String? nama,
    String? payment_method,
    String? id,
    int? nominal,
    String? type,
    String? input_by,
    String? input_date,
    String? status,
    String? valid_by,
    String? valid_date,
    String? bukti_pembayaran,
    String? kode_transaksi,
  }) =>
      AddTransactionModel(
          nama: nama ?? this.nama,
          nominal: nominal ?? this.nominal,
          id: id ?? this.id,
          type: type ?? this.type,
          payment_method: payment_method ?? this.payment_method,
          input_date: input_date ?? this.input_date,
          input_by: input_by ?? this.input_by,
          status: status ?? this.status,
          valid_by: valid_by ?? this.valid_by,
          valid_date: valid_date ?? this.valid_date,
          kode_transaksi: kode_transaksi ?? this.kode_transaksi,
          bukti_pembayaran: bukti_pembayaran ?? this.bukti_pembayaran);

  factory AddTransactionModel.fromJson(Map<String, dynamic> data) =>
      AddTransactionModel(
          nama: data['nama'],
          nominal: data['nominal'],
          id: data['id'],
          type: data['type'],
          payment_method: data['payment_method'],
          input_date: data['input_date'],
          input_by: data['input_by'],
          status: data['status'],
          valid_by: data['valid_by'],
          valid_date: data['valid_date'],
          kode_transaksi: data['kode_transaksi'],
          bukti_pembayaran: data['bukti_pembayaran']);

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "nominal": nominal,
        "id": id,
        "type": type,
        "payment_method": payment_method,
        "input_date": input_date,
        "input_by": input_by,
        "status": status,
        "valid_by": valid_by,
        "valid_date": valid_date,
        "kode_transaksi": kode_transaksi,
        "bukti_pembayaran": bukti_pembayaran
      };
}
