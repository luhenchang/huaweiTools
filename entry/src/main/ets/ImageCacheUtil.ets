//图片缓存工具
import File from '@system.file'
import fileUri from '@ohos.file.fileuri';
import { Md5Util } from './crypto/Md5Util';
import { BusinessError, request } from '@kit.BasicServicesKit';
import fs, { ListFileOptions, ReadOptions, ReadTextOptions, WriteOptions } from '@ohos.file.fs';
import { staticMap } from '@kit.MapKit';
import { image } from '@kit.ImageKit';

export class ImageCacheUtil {
  static imageFileName = 'images'
  static readonly separator: string = '/'
  static readonly cacheMaxSize = 1024 * 1024 * 200
  //图片文件夹路径
  static readonly dir = getContext().cacheDir + ImageCacheUtil.separator + ImageCacheUtil.imageFileName

  /**
   * 文件下载工具方法
   * @param context 上下文
   * @param downloadUrl 图片地址
   * @param downloadPath 缓存地址
   */
  static downLoadFile(
    context: Context,
    downloadUrl: string
  ): Promise<image.PixelMap | string | undefined> {
    return new Promise(async (resolve, reject) => {
      try {
        //1、获取图片类型例如 .png/.jpg/.weep等
        let imageType = downloadUrl.substring(downloadUrl.lastIndexOf('.'))
        //2、获取MD5摘要
        let downloadUrlMd5 = await new Md5Util().doMd(downloadUrl)
        //3、获取图片文件名称
        let newImageFileName = ImageCacheUtil.getImageFileName(downloadUrlMd5, imageType)
        //4、拼接下载路径地址
        let downloadPath = ImageCacheUtil.dir + ImageCacheUtil.separator + newImageFileName
        //5、检测图片文件夹是否存在，否->创建
        let existedBefore = ImageCacheUtil.checkAndMkdirSync(ImageCacheUtil.dir)
        //之前存在才应该去遍历文件，然后更新文件
        if (existedBefore) {
          //6、检测文件夹大小如果大于200M，就需要删除一半的图片资源
          ImageCacheUtil.clearHalfCache(ImageCacheUtil.dir)
          //判断此图片资源是否已经被缓存到了文件夹下面
          let findResult = await ImageCacheUtil.findFileNameInFolder(ImageCacheUtil.dir, downloadUrlMd5)
          //如果存在去更新文件名称，否则去下载
          if (findResult[0]) {
            let renameSuccess = await ImageCacheUtil.renameOfImageByDataTime(findResult[1], newImageFileName)
            if (renameSuccess) {
              let pixelMap = await ImageCacheUtil.uriOrPathConvertPixelMap(downloadPath)
              if (pixelMap) {
                resolve(pixelMap)
                return
              }
              resolve(downloadUrl)
              return
            }
          }
        }

        //如果图片文件夹不存在就去下载
        request.downloadFile(context, { url: downloadUrl, filePath: downloadPath })
          .then((downloadTask: request.DownloadTask) => {
            downloadTask.on('complete', async () => {
              console.info('message::success' + downloadPath)
              let result = await ImageCacheUtil.uriOrPathConvertPixelMap(downloadPath)
              resolve(result);
            })
            downloadTask.on('fail', (erro) => {
              console.info('message::fail=' + erro)
              //下载失败需要删除本地路径，然后返回下载缓存路径
              ImageCacheUtil.clearImageFailCache(downloadPath)
              resolve(downloadUrl)
            })
          }).catch((err: BusinessError) => {
          ImageCacheUtil.clearImageFailCache(downloadPath)
          console.error('message::err' + err.stack?.toString())
          resolve(downloadUrl)
        })
      } catch (e) {
        console.error('message::err' + e.stack?.toString())
        resolve(downloadUrl)
      }
    })
  }

  static async uriOrPathConvertPixelMap(path: string): Promise<image.PixelMap | undefined> {
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
  static clearHalfCache(dir: string) {
    let folderSize = ImageCacheUtil.getDirectorySize(dir)
    if (folderSize >= ImageCacheUtil.cacheMaxSize) {
      let files = fs.listFileSync(dir)
      let endFiles = files.sort((a, b) => {
        return ImageCacheUtil.extractTimestamp(a) - ImageCacheUtil.extractTimestamp(b)
      })
      endFiles.forEach((deletePath, index) => {
        if (index < endFiles.length / 2) {
          fs.unlinkSync(dir + ImageCacheUtil.separator + deletePath)
        }
      })
    }
  }

  /**
   * 获取输入路径下面所有文件的大小之合
   * @param path
   * @returns
   */
  static getDirectorySize(path: string): Number {
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
    return size
  }


  // 提取时间戳的函数
  static extractTimestamp(path: string): number {
    const match = path.match(/_(\d+)\./);
    return match ? parseInt(match[1], 10) : 0; // 如果没有找到时间戳，返回 0
  }

  /**
   * 检测是否文件夹存在，不存在创建
   * @param dir
   */
  static checkAndMkdirSync(dir: string): boolean {
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
  static async renameOfImageByDataTime(oldFileName: string, newFileName: string) {
    let imageOldPath = ImageCacheUtil.dir + ImageCacheUtil.separator + oldFileName
    let imageNewPath = ImageCacheUtil.dir + ImageCacheUtil.separator + newFileName
    return await ImageCacheUtil.rename(imageOldPath, imageNewPath)
  }

  /**
   *
   */

  /**
   * 重命名文件或文件夹
   */
  static async rename(oldPath: string, newPath: string): Promise<boolean> {
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
  static async findFileInFolder(folderDir: string, fileName: string): Promise<boolean> {
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
  static async findFileNameInFolder(folderDir: string, fileName: string): Promise<[boolean, string]> {
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

  static getImageFileName(fileName: string, fileType: string): string {
    return fileName + `_${new Date().getTime()}`
  }

  static async clearImageCache() {
    let listFiles = await fs.listFile(ImageCacheUtil.dir)
    listFiles.forEach(async (fileName: string) => {
      let clearImagePath = ImageCacheUtil.dir + ImageCacheUtil.separator + fileName
      await fs.unlink(clearImagePath)
    })
  }

  /**
   * 清楚下载失败的图片文件
   * @param path
   */
  static async clearImageFailCache(path: string) {

    await fs.unlink(path)
  }
}




