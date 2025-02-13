abstract class ISocketStockData {}

num? parse(dynamic data) {
  if (data == null) return null;

  return num.tryParse(data.toString().trim());
}

class IStockInfoData extends ISocketStockData {
  String? e;
  String? symbol;
  String? si;
  String? fn;
  String? st;
  num? ceilingPrice;
  num? floorPrice;
  num? sl;
  num? referencePrice;
  String? bidPrice3;
  num? bidVol3;
  String? bidPrice2;
  num? bidVol2;
  String? bidPrice1;
  num? bidVol1;
  num? closePrice;
  num? lastCloseVol;
  num? change;
  num? changePercent;
  String? offerPrice1;
  num? offerVol1;
  String? offerPrice2;
  num? offerVol2;
  String? offerPrice3;
  num? offerVol3;
  num? totalTrading;
  num? totalTradingValue;
  num? high;
  num? averagePrice;
  num? low;
  String? tsi;
  String? cwt;
  String? md;
  String? fc;

  IStockInfoData(
      {this.e,
      this.symbol,
      this.si,
      this.fn,
      this.st,
      this.ceilingPrice,
      this.floorPrice,
      this.sl,
      this.referencePrice,
      this.bidPrice3,
      this.bidVol3,
      this.bidPrice2,
      this.bidVol2,
      this.bidPrice1,
      this.bidVol1,
      this.closePrice,
      this.lastCloseVol,
      this.change,
      this.changePercent,
      this.offerPrice1,
      this.offerVol1,
      this.offerPrice2,
      this.offerVol2,
      this.offerPrice3,
      this.offerVol3,
      this.totalTrading,
      this.totalTradingValue,
      this.high,
      this.averagePrice,
      this.low,
      this.tsi,
      this.cwt,
      this.md,
      this.fc});

  IStockInfoData.fromJson(Map<String, dynamic> json) {
    e = json['e'];
    symbol = json['sb'];
    si = json['si'];
    fn = json['fn'];
    st = json['st'];
    ceilingPrice = parse(json['cl']);
    sl = json['sl'];
    referencePrice = parse(json['re']);
    floorPrice = parse(json['fl']);
    bidPrice3 = json['b3']?.toString();
    bidVol3 = parse(json['v3']);
    bidPrice2 = json['b2']?.toString();
    bidVol2 = parse(json['v2']);
    bidPrice1 = json['b1']?.toString();
    bidVol1 = parse(json['v1']);
    closePrice = parse(json['ocp'] ?? json['cp']);
    lastCloseVol = parse(json['ocv'] ?? json['cv']);
    change = parse(json['och'] ?? json['ch']);
    changePercent = parse(json['chp']);
    offerPrice1 = json['s1']?.toString();
    offerVol1 = parse(json['u1']);
    offerPrice2 = json['s2']?.toString();
    offerVol2 = parse(json['u2']);
    offerPrice3 = json['s3']?.toString();
    offerVol3 = parse(json['u3']);
    totalTrading = parse(json['tt']);
    totalTradingValue = parse(json['tv']) ?? parse(json['TV']);
    high = json['hi'];
    averagePrice = json['ap'];
    low = json['lo'];
    tsi = json['tsi'];
    cwt = json['cwt'];
    md = json['md'];
    fc = json['fc'];
  }
}

class IMarketData extends ISocketStockData {
  String? e;
  String? symbol;
  num? sequenceMsg;
  num? closePrice;
  num? volume;
  DateTime? time;

  IMarketData({
    this.e,
    this.symbol,
    this.closePrice,
    this.volume,
    this.time,
  });

  IMarketData.fromJson(Map<String, dynamic> json) {
    final mills = parse(json['t'])?.toInt();

    e = json['e'];
    symbol = json['s'];
    closePrice = parse(json['p']);
    volume = parse(json['q']);
    time = mills == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(mills * 1000);
  }
}

class IMarketInfoData extends ISocketStockData {
  String? e;
  String? marketCode;
  num? marketIndex;
  num? totalVolume;
  num? volume;

  // hh:mm:ss
  String? time;

  num? change;
  num? changePercent;

  IMarketInfoData({
    this.e,
    this.marketCode,
    this.marketIndex,
    this.time,
    this.volume,
    this.totalVolume,
    this.change,
    this.changePercent,
  });

  IMarketInfoData.fromJson(Map<String, dynamic> json) {
    e = json['e'];
    marketCode = json['mc'];
    marketIndex = parse(json['mi']);
    totalVolume = parse(json['tv']) ?? parse(json['TV']);
    volume = parse(json['v']);
    change = parse(json['ich']);
    changePercent = parse(json['ipc']);
    time = json['it'];
  }
}
