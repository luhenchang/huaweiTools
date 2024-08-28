import File from '@system.file';
import { stream } from '@kit.ArkTS';
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';

/**
 * FileTypeUtils 类用于识别文件类型
 */
export class FileTypeUtils {
  private static readonly MIMETYPES_PROPERTIES = "FileTypes.properties";
  private static fileTypes: Map<string, string> = new Map();
  private static instance: FileTypeUtils | null = null;

  private constructor() {
    //this.loadProperties();
  }

  /**
   * 获取 FileTypeUtils 实例
   * @param context 上下文对象
   * @returns FileTypeUtils 实例
   */
  public static getInstance(): FileTypeUtils {
    if (FileTypeUtils.instance === null) {
      FileTypeUtils.instance = new FileTypeUtils();
    }
    return FileTypeUtils.instance;
  }

  /**
   * 加载 MIME 类型配置文件
   */
  // private async loadProperties() {
  //   try {
  //     const resourceManager = ResourceManager.getResourceManager();
  //     const inputStream = await resourceManager.getRawFile(this.MIMETYPES_PROPERTIES);
  //
  //     if (inputStream) {
  //       const bytes = await this.readAllBytes(inputStream);
  //       const properties = ZSONObject.parse(new TextDecoder().decode(bytes));
  //
  //       for (const [key, value] of properties.entries()) {
  //         FileTypeUtils.fileTypes.set(key, value);
  //       }
  //     }
  //   } catch (e) {
  //     console.error(e);
  //   }
  // }

  /**
   * 读取 InputStream 中的所有字节
   * @param inputStream InputStream 对象
   * @returns 字节数组
   */
  // private async readAllBytes(inputStream: InputStream): Promise<Uint8Array> {
  //   Stream.read
  //   const chunks: Uint8Array[] = [];
  //   let chunk: Uint8Array;
  //
  //   while ((chunk = await inputStream.read()) !== null) {
  //     chunks.push(chunk);
  //   }
  //
  //   return new Uint8Array(chunks.reduce((acc, val) => acc.concat(Array.from(val)), []));
  // }
  async readAllBytes(filePath: string) {
    // 打开文件流
    const inputStream = fs.createReadStream(filePath);
    const inputStreamSyn = fs.createStreamSync(filePath, 'r+');
    let bufSize = inputStream.bytesRead;
    let readSize = 0;
    let buf = new ArrayBuffer(bufSize);
    let readOptions: ReadOptions = {
      offset: readSize,
      length: bufSize
    };
    await inputStreamSyn.read(buf, readOptions);
    // 关闭文件流
    inputStreamSyn.closeSync();
    console.log('buf.byteLength::=' + buf.byteLength);
  }

  async readAllBytess(filePath: string): Promise<Uint8Array> {
    const inputStream = fs.createReadStream(filePath);
    const chunks: Uint8Array[] = [];
    let totalLength = inputStream.bytesRead;
    // 将所有字节拼接到一个新的 Uint8Array 中
    const result = new Uint8Array(totalLength);
    let offset = 0;
    for (const chunk of chunks) {
      result.set(chunk, offset);
      offset += chunk.length;
    }

    return result;
  }

  /**
   * 获取文件类型
   * @param file 文件对象
   * @returns 文件类型字符串
   */
  // public async getFileType(file: File): Promise<string | null> {
  //   if (!file || !(await file.exists()) || (await file.length()) < 11) {
  //     return null;
  //   }
  //
  //   const header = await this.get10ByteHeader(file);
  //   let fileSuffix = FileTypeUtils.fileTypes.get(header) || null;
  //
  //   if (fileSuffix === null) {
  //     const keySearchPrefix = header.substring(0, 5);
  //     for (const [key, value] of FileTypeUtils.fileTypes) {
  //       if (key.includes(keySearchPrefix)) {
  //         fileSuffix = value;
  //         break;
  //       }
  //     }
  //   }

  //   if (fileSuffix === null) {
  //     const header3Byte = await this.get3ByteHeader(file);
  //     fileSuffix = FileTypeUtils.fileTypes.get(header3Byte) || null;
  //   }
  //
  //   return fileSuffix;
  // }

  /**
   * 从文件中读取前 10 个字节
   * @param file 文件对象
   * @returns 十六进制字符串
   */
  // private async get10ByteHeader(file: File): Promise<string> {
  //   return this.getFileHeader(file, 10);
  // }

  /**
   * 从文件中读取前 3 个字节
   * @param file 文件对象
   * @returns 十六进制字符串
   */
  // private async get3ByteHeader(file: File): Promise<string> {
  //   return this.getFileHeader(file, 3);
  // }

  /**
   * 从文件中读取指定长度的字节
   * @param file 文件对象
   * @param length 读取长度
   * @returns 十六进制字符串
   */
  // private async getFileHeader(file: File, length: number): Promise<string> {
  //   try {
  //     const inputStream = new FileInputStream(file);
  //     const bytes = new Uint8Array(length);
  //     await inputStream.read(bytes);
  //     return this.bytesToHexString(bytes);
  //   } catch (e) {
  //     console.error(e);
  //     return '';
  //   }
  // }

  /**
   * 将字节数组转换为十六进制字符串
   * @param src 字节数组
   * @returns 十六进制字符串
   */
  private bytesToHexString(src: Uint8Array): string {
    return Array.from(src)
      .map(b => b.toString(16).padStart(2, '0'))
      .join('')
      .toUpperCase();
  }
}
