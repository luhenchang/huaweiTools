import { IBaseEncrypt } from './IBaseEncrypt';
import cryptoFramework from '@ohos.security.cryptoFramework';
import { StrUtil } from '../utils/StrUtil';

const TAG: string = "AesUtil"

const AES_VECTOR = "\u007F}{y<usqomkigeca";
const AES_KEY = "@/.D>XVX5zhOdwj8";

export class AesUtil implements IBaseEncrypt {
  static getInstance(): IBaseEncrypt {
    return new AesUtil()
  }

  async encode(original: Uint8Array): Promise<Uint8Array> {
    let realKey: string = this.decryptStr(AES_KEY)
    let symKey: cryptoFramework.SymKey = await this.genSymKeyByData(StrUtil.strToUint8Array(realKey));
    let plainText: cryptoFramework.DataBlob = { data: original };
    let encryptText = await this.encryptMessagePromise(symKey, plainText);
    return encryptText.data
  }

  async decode(encrypt: Uint8Array): Promise<Uint8Array> {
    let realKey: string = this.decryptStr(AES_KEY)
    let symKey: cryptoFramework.SymKey = await this.genSymKeyByData(StrUtil.strToUint8Array(realKey));
    let plainText: cryptoFramework.DataBlob = { data: encrypt };
    let decryptText = await this.decryptMessagePromise(symKey, plainText);
    return decryptText.data
  }

  private decryptStr(str: string): string {
    try {
      let reversedStr = str.split('').reverse().join('');
      let result: string[] = [];

      for (let i = 0; i < reversedStr.length; i++) {
        let c = reversedStr.charCodeAt(i);
        result.push(String.fromCharCode(c - i));
      }

      return result.join('');
    } catch (e) {
      console.error(e);
    }
    return "";
  }

  private genIvParamsSpec() {
    let realIv = this.decryptStr(AES_VECTOR)
    // ApLog.i("realIv:" + realIv, TAG, true)
    let dataIv = StrUtil.strToUint8Array(realIv)
    let ivBlob: cryptoFramework.DataBlob = { data: dataIv };
    let ivParamsSpec: cryptoFramework.IvParamsSpec = {
      algName: "IvParamsSpec",
      iv: ivBlob
    };
    return ivParamsSpec;
  }


  // 加密消息
  private async encryptMessagePromise(symKey: cryptoFramework.SymKey, plainText: cryptoFramework.DataBlob) {
    let cipher = cryptoFramework.createCipher('AES128|CBC|PKCS7');
    let iv = this.genIvParamsSpec();
    await cipher.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, iv);
    let cipherData = await cipher.doFinal(plainText);
    // ApLog.i("encrypt ok", TAG, true)
    return cipherData;
  }

  // 解密消息
  private async decryptMessagePromise(symKey: cryptoFramework.SymKey, cipherText: cryptoFramework.DataBlob) {
    let decoder = cryptoFramework.createCipher('AES128|CBC|PKCS7');
    let iv = this.genIvParamsSpec();
    await decoder.init(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, iv);
    let decryptData = await decoder.doFinal(cipherText);
    // ApLog.i("decrypt ok", TAG, true)
    return decryptData;
  }

  private async genSymKeyByData(symKeyData: Uint8Array) {
    let symKeyBlob: cryptoFramework.DataBlob = { data: symKeyData };
    let aesGenerator = cryptoFramework.createSymKeyGenerator('AES128');
    let symKey = await aesGenerator.convertKey(symKeyBlob);
    // ApLog.i('convertKey success', TAG, true);
    return symKey;
  }
}