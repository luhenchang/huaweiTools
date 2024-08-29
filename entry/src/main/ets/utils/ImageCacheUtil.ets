//图片缓存工具
import { Md5Util } from '../crypto/Md5Util';
import { BusinessError, request } from '@kit.BasicServicesKit';
import fs, { ReadOptions } from '@ohos.file.fs';
import { image } from '@kit.ImageKit';
import { buffer } from '@kit.ArkTS';
import util from '@ohos.util';
import { Context } from '@kit.AbilityKit';

export class ImageCacheUtil {
  TAG = ImageCacheUtil.name
  readonly context: Context
  //缓存文件默认路径
  readonly imageFolderName: string = 'images'
  //文件路径分隔符
  readonly separator: string = '/'
  //图片文件夹路径
  readonly dir = getContext().cacheDir + this.separator
  //200M 是文件夹默认最大上线，如果大于这个数据就需要删除一般空间了。
  readonly cacheMaxSize = 1024 * 1024 * 200
  //不进行缓存的图直接返回路径，并删除本地缓存
  //例如['.gif','jpg'] 就会将.gif文件和jpg文件不进行缓存，直接返回url，作为Image默认加载。
  readonly noCatchImageType: string[] = []

  constructor(builder: ImageCacheUtil.Builder) {
    this.context = builder.context
    this.imageFolderName = builder.imageFolderName
    this.dir += builder.imageFolderName
    this.cacheMaxSize = builder.cacheMaxSize
    this.noCatchImageType.push(...builder.noCatchImageType)
  }

  /**
   * 文件下载并拿到缓存返回给调用者，如果下载和图片解析失败返回链接，通过下载链接进行加载，利用系统缓存机制进行加载。
   * @param context 上下文
   * @param downloadUrl 图片地址
   * @param downloadPath 缓存地址
   * @returns 返回PixelMap 失败返回downloadUrl
   */
  downLoadCacheFile(
    downloadUrl: string
  ): Promise<image.PixelMap | string | undefined> {
    return new Promise(async (resolve, reject) => {
      try {
        //1、获取图片类型例如 .png/.jpg/.weep等。
        //目前不用图片类型，应为图片链接可能无任何类型信息。
        //2、获取MD5摘要
        let downloadUrlMd5 = await new Md5Util().doMd(downloadUrl)
        //3、获取图片文件名称
        let newImageFileName = this.getImageFileName(downloadUrlMd5)
        //4、拼接下载路径地址
        let downloadPath = this.dir + this.separator + newImageFileName
        //5、检测图片文件夹是否存在，否->创建
        let existedBefore = this.checkAndMkdirSync(this.dir)
        //之前存在才应该去遍历文件，然后更新文件
        if (existedBefore) {
          //6、检测文件夹大小如果大于200M，就需要删除一半的图片资源
          await this.clearHalfCache(this.dir)
          //判断此图片资源是否已经被缓存到了文件夹下面
          let findFileExistInFolder = await this.findFileNameInFolder(this.dir, downloadUrlMd5)
          //如果存在去更新文件名称，否则去下载
          if (findFileExistInFolder[0]) {
            let renameSuccess = await this.renameOfImageByDataTime(findFileExistInFolder[1], newImageFileName)
            if (renameSuccess) {
              let pixelMap = await this.uriOrPathConvertPixelMap(downloadPath)
              if (pixelMap) {
                resolve(pixelMap)
                return
              }
              //文件编码为pixelMap失败，所以删除文件并再次下载
              this.clearImageFailCache(downloadPath);
              let resultEnd = await this.downloadFile(this.context, downloadUrl, downloadPath)
              resolve(resultEnd)
              return
            }
          }
        }
        //如果图片文件夹不存在就去下载
        let resultEnd = await this.downloadFile(this.context, downloadUrl, downloadPath)
        resolve(resultEnd)
      } catch (e) {
        console.error(this.TAG + `::downLoadCacheFile error message = ${e.stack?.toString()}`)
        resolve(downloadUrl)
      }
    })
  }

  async getImageType(filePath: string, readByteLength: number = 12): Promise<string> {
    let readBuf = await this.readAllBytes(filePath, readByteLength)
    let fileTypeHeader = this.stringToHex(buffer.from(readBuf).toString()).toUpperCase()
    if (fileTypeHeader.includes('504E470D0A1A0A')) {
      return '.png'
    } else if (fileTypeHeader.includes('4A464946')) {
      return '.jpg'
    } else if (fileTypeHeader.includes('474946')) {
      return '.gif'
    } else if (fileTypeHeader.includes('57454250')) {
      return '.webp'
    }
    return 'fail'
  }

  async readAllBytes(filePath: string, readByteLength: number): Promise<ArrayBuffer> {
    // 打开文件流
    let inputStream = fs.createStreamSync(filePath, 'r+');
    // 以流的形式读取源文件内容并写入目的文件
    let bufSize = readByteLength;
    let readSize = 0;
    let buf = new ArrayBuffer(bufSize);
    let readOptions: ReadOptions = {
      offset: readSize,
      length: bufSize
    };
    await inputStream.read(buf, readOptions);
    // 关闭文件流
    inputStream.closeSync();
    return buf
  }

  //十六进制转为字符串
  hexToString(hex: string): string {
    // 将十六进制字符串转换为 Uint8Array
    const bytes = new Uint8Array(hex.match(/.{1,2}/g)!.map(byte => parseInt(byte, 16)));
    // 使用 TextDecoder 解码字节数组为字符串
    let decoder = util.TextDecoder.create('utf-8', { ignoreBOM: true })
    return decoder.decodeWithStream(bytes);
  }

  //字符串转为十六进制
  stringToHex(str: string) {
    let hex = '';
    for (let i = 0; i < str.length; i++) {
      let hexCharCode = str.charCodeAt(i).toString(16);
      // 确保每个字符的十六进制编码占两位，不足补零
      hex += ('00' + hexCharCode).slice(-2);
    }
    return hex;
  }

  /**
   * 网络下载图片方法
   * @param context
   * @param downloadUrl
   * @param downloadPath
   * @returns
   */
  private async downloadFile(context: Context, downloadUrl: string,
    downloadPath: string): Promise<image.PixelMap | string | undefined> {
    return new Promise((resolve, reject) => {
      request.downloadFile(context, { url: downloadUrl, filePath: downloadPath })
        .then((downloadTask: request.DownloadTask) => {
          downloadTask.on('complete', async () => {
            console.info('message::success' + downloadPath);
            let type = await this.getImageType(downloadPath)
            if (this.noCatchImageType.includes(type)) {
              this.clearImageFailCache(downloadPath)
              resolve(downloadUrl);
              return
            }
            let catchPixelMap = await this.uriOrPathConvertPixelMap(downloadPath);
            if (catchPixelMap) {
              resolve(catchPixelMap)
              return
            }
            resolve(downloadUrl);
            return
          });
          downloadTask.on('fail', (error) => {
            console.error(this.TAG + `::downloadFile downloadTask fail error= ${error?.toString()}`)
            //下载失败需要删除本地路径，然后返回下载缓存路径
            this.clearImageFailCache(downloadPath);
            resolve(downloadUrl);
            return
          });
        })
        .catch((err: BusinessError) => {
          console.error(`${this.TAG}::downloadFile Failed to request the download. Code: ${err.code}, message: ${err.message}`);
          this.clearImageFailCache(downloadPath);
          resolve(downloadUrl);
          return
        });
    })
  }

  /**
   * 通过path和url将文件编码为pixelMap
   * @param path
   * @returns
   */
  async uriOrPathConvertPixelMap(path: string): Promise<image.PixelMap | undefined> {
    try {
      let file = fs.openSync(path, fs.OpenMode.READ_ONLY)
      const imageSource: image.ImageSource = image.createImageSource(file.fd)
      fs.closeSync(file)
      let decodingOptions: image.DecodingOptions = {
        editable: true,
        desiredPixelFormat: 3,
      }
      let pixelMap = await imageSource.createPixelMap(decodingOptions)
      return pixelMap
    } catch (e) {
      return undefined
    }
  }

  /**
   * 清除一半的缓存
   * @param dir
   */
  async clearHalfCache(dir: string): Promise<void> {
    let folderSize = this.getDirectorySize(dir)
    if (folderSize >= this.cacheMaxSize) {
      let files = fs.listFileSync(dir)
      let endFiles = files.sort((a, b) => {
        return this.extractTimestamp(a) - this.extractTimestamp(b)
      })
      endFiles.forEach((deletePath, index) => {
        if (index < endFiles.length / 2) {
          fs.unlinkSync(dir + this.separator + deletePath)
        }
      })
    }
  }

  /**
   * 获取输入路径下面所有文件的大小之合
   * @param path
   * @returns
   */
  getDirectorySize(path: string): Number {
    let size = 0

    class ListFileOption { //制定筛选规则
      public recursion: boolean = true; //true为获取该文件夹下所有文件,包括子目录文件
      public listNum: number = 0; //获取文件的数量，为0时获取所有文件
    }

    let option = new ListFileOption()
    let filenames = fs.listFileSync(path, option)
    for (let i = 0; i < filenames.length; i++) {
      size += fs.statSync(path + filenames[i]).size
    }
    console.log(`folder size is ${size / 1024 / 1024}M`)
    return size
  }


  // 提取时间戳的函数
  extractTimestamp(path: string): number {
    const match = path.match(/_(\d+)\./);
    return match ? parseInt(match[1], 10) : 0; // 如果没有找到时间戳，返回 0
  }

  /**
   * 检测是否文件夹存在，不存在创建
   * @param dir
   */
  checkAndMkdirSync(dir: string): boolean {
    let exist = fs.accessSync(dir)
    if (!exist) {
      fs.mkdirSync(dir)
    }
    return exist
  }

  /**
   *
   * @param oldFileName
   */
  async renameOfImageByDataTime(oldFileName: string, newFileName: string) {
    let imageOldPath = this.dir + this.separator + oldFileName
    let imageNewPath = this.dir + this.separator + newFileName
    return await this.rename(imageOldPath, imageNewPath)
  }


  /**
   * 重命名文件或文件夹
   */
  async rename(oldPath: string, newPath: string): Promise<boolean> {
    try {
      await fs.rename(oldPath, newPath)
      return true
    } catch (erro) {
      return false
    }
  }

  /**
   * 在文件里面进行遍历匹配传入的'图片'是否存在
   * @param folderDir 需要遍历文件夹路径
   * @param fileName 需要查询是否存在文件名称
   * return
   */
  async findFileInFolder(folderDir: string, fileName: string): Promise<boolean> {
    let listFiles = await fs.listFile(folderDir)
    let findIndexNumber = listFiles.findIndex((value) => {
      return value.match(fileName)
    })
    return findIndexNumber > -1
  }

  /**
   * 在文件里面进行遍历匹配传入的'图片'是否存在
   * @param folderDir 需要遍历文件夹路径
   * @param fileName 需要查询是否存在文件名称
   * return
   */
  async findFileNameInFolder(folderDir: string, fileName: string): Promise<[boolean, string]> {
    let listFiles = await fs.listFile(folderDir)
    let findIndexNumber = listFiles.findIndex((value) => {
      return value.match(fileName)
    })
    //大于-1表示存在
    if (findIndexNumber > -1) {
      return [true, listFiles[findIndexNumber]]
    }
    return [false, '']
  }

  /**
   * 获取最新的时间戳文件名称，方便监控
   * @param fileName
   * @returns
   */
  getImageFileName(fileName: string): string {
    return fileName + `_${new Date().getTime()}`
  }

  async clearImageCache() {
    let listFiles = await fs.listFile(this.dir)
    listFiles.forEach(async (fileName: string) => {
      let clearImagePath = this.dir + this.separator + fileName
      await fs.unlink(clearImagePath)
    })
  }

  /**
   * 清楚下载失败的图片文件
   * @param path
   */
  async clearImageFailCache(path: string) {
    await fs.unlink(path)
  }
}


export namespace ImageCacheUtil {
  export class Builder {
    imageFolderName: string = 'images'
    cacheMaxSize: number = 1024 * 1024 * 200 //默认200M
    context: Context
    noCatchImageType: string[] = []

    public constructor(context: Context) {
      this.context = context
    }

    public setImageFolderName(imageFolderName: string) {
      this.imageFolderName = imageFolderName
      return this
    }

    public setCacheMaxSize(cacheMaxSize: number) {
      this.cacheMaxSize = cacheMaxSize
      return this
    }

    public setNoCatchImageType(noCatchImageType: string[]) {
      this.noCatchImageType.push(...noCatchImageType)
      return this
    }

    public build(): ImageCacheUtil {
      return new ImageCacheUtil(this)
    }
  }
}



