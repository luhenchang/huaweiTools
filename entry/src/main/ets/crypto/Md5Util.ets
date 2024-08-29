import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';
import { StrUtil } from '../utils/StrUtil';

export class Md5Util {
  async doMd(message: string) {
    let mdAlgName = 'MD5'; // 摘要算法名
    let md = cryptoFramework.createMd(mdAlgName);
    // 数据量较少时，可以只做一次update，将数据全部传入，接口未对入参长度做限制
    await md.update({ data: new Uint8Array(buffer.from(message, 'utf-8').buffer) });
    let mdResult = await md.digest();
    let md5Str = StrUtil.uint8ArrayToShowStr(mdResult.data)
    console.info('Md result:' + md5Str);
    return md5Str
  }
}