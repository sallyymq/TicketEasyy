class CCard {
  String Complex;
  String Status;
  String BusNumber;

  CCard({
    required this.Complex,
    required this.Status,
    required this.BusNumber,
  });

  String get _Complex => Complex;
  String get _Status => Status;
  String get _BusNumber => BusNumber;
}