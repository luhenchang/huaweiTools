

export namespace DeviceInfoConstants{

  export class DeviceType{
    static readonly TYPE_PHONE = 100;
    static readonly TYPE_TABLET = 101;
    static readonly TYPE_2IN1 = 102;
  }

  export class OperatorSystemType{
    static readonly OS_UNKNOWN = 0;
    static readonly OS_ANDROID = 2;
    static readonly OS_HARMONY = 9;
    static readonly OS_IOS_TV = 3;
    static readonly OS_IOS = 13;
    static readonly OS_PS4 = 22;
  }

  export class CarrierType{
    static readonly CARRIER_CMCC = "CMCC";
    static readonly CARRIER_CUCC = "CUCC";
    static readonly CARRIER_CTCC = "CTCC";
    static readonly CARRIER_UNKNOWN = "UNKNOW";
  }

  export class IndividuationState{
    static readonly INDIVIDUATION_GRANTED = 1;
    static readonly INDIVIDUATION_DENIED = 0;
    static readonly CONFIG_INDIVIDUATION_GRANTED = 0;
    static readonly CONFIG_INDIVIDUATION_DENIED = 1;
  }

  class Entry{
    code = 0
    msg = ""
    constructor(c: number, msg: string) {
      this.code = c
      this.msg = msg
    }
  }

  export  class ConnectType {
    static readonly CONNECT_TYPE_UNKNOWN =new Entry(0, "unknown")
    static readonly CONNECT_TYPE_WIFI =new Entry(1, "wifi")
    static readonly CONNECT_TYPE_2G =new Entry(2, "2G")
    static readonly CONNECT_TYPE_3G =new Entry(3, "3G")
    static readonly CONNECT_TYPE_4G =new Entry(4, "4G")
    static readonly CONNECT_TYPE_5G =new Entry(5, "5G")
  }
  export  class CountryType{
    static readonly COUNTRY_OTHER_TYPE =new Entry(0,"OTHER")//其他国家，以后要扩展到其他国家
    static readonly COUNTRY_CHINA_TYPE =new Entry(1,"CN");//中国

  }

}