import { ArrayList } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'

export const images = [
  'https://www.baidu.com/img/flexible/logo/pc/result@2.png',
// 'https://p3-passport.byteacctimg.com/img/user-avatar/0eeb7cf052adc130878c997df2233fa5~180x180.awebp',
// 'https://img10.360buyimg.com/img/jfs/t1/176863/16/41608/14330/668e3421F64b41094/15c9d9130b980a51.png',
// 'https://www.zhipin.com/sem/static/img/banner.97f904e9.png',
// 'https://img1.baidu.com/it/u=3809505498,1140154284&fm=253&fmt=auto&app=138&f=JPEG?w=641&h=500',
// 'https://img.zcool.cn/community/010ddd6034cd9e11013ef90fe189f7.gif',
// 'https://5b0988e595225.cdn.sohucs.com/q_70,c_zoom,w_640/images/20190514/eca8cb6ea55c42e2a1adec000b95e678.gif',
// 'https://img0.baidu.com/it/u=143672386,1614197866&fm=253&fmt=auto&app=138&f=JPEG?w=300&h=300',
// 'https://img0.baidu.com/it/u=348319454,612046564&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=750',
// 'https://picb2.photophoto.cn/40/293/40293462_1.jpg',
// 'https://t7.baidu.com/it/u=3406125714,2513313326&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=1849127162,2977890911&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=2326659061,2298551036&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=705472838,2907410278&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=1443561963,713565800&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=2571909033,1022229835&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=4276382833,263521692&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=996072019,1152436064&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=70437373,1457649157&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=3049474096,4201820682&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=41261253,3262209613&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=434120365,518766507&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=3118091038,126846670&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=1602604517,288370104&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=3034799576,2420598506&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=2957905518,3348782918&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=3076737042,3523621930&fm=193&f=GIF',
// 'https://t7.baidu.com/it/u=2825267387,2477916500&fm=193&f=GIF',
// 'https://wx2.sinaimg.cn/mw690/006GBbhsgy1hrpxcn145kj30u00u0tbm.jpg',
// 'https://img1.baidu.com/it/u=1767128743,3433756890&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1285',
// 'http://img1.baidu.com/it/u=3676659290,2130457216&fm=253&app=138&f=JPEG?w=800&h=1271',
// 'http://img0.baidu.com/it/u=2624070685,62615284&fm=253&app=138&f=JPEG?w=800&h=1259',
// 'http://img1.baidu.com/it/u=3066845475,2309040221&fm=253&app=138&f=JPEG?w=800&h=1274',
// 'http://img1.baidu.com/it/u=1330517162,3424969054&fm=253&app=138&f=JPEG?w=800&h=1248',
// 'http://img2.baidu.com/it/u=3903160154,2859539992&fm=253&app=138&f=JPEG?w=800&h=1281',
// 'http://img2.baidu.com/it/u=3659808534,1318280014&fm=253&app=138&f=JPEG?w=800&h=1267',
// 'http://img0.baidu.com/it/u=3702460088,4280564933&fm=253&app=138&f=JPEG?w=800&h=1271',
// 'http://img0.baidu.com/it/u=1190152790,2123848285&fm=253&app=138&f=JPEG?w=800&h=1314',
// 'http://img2.baidu.com/it/u=699705439,1146811613&fm=253&app=138&f=JPEG?w=800&h=1300',
// 'http://img2.baidu.com/it/u=3679829839,3225115511&fm=253&app=138&f=JPEG?w=800&h=1268',
// 'https://ww3.sinaimg.cn/mw690/006GBbhsgy1hrr8fv4l5qj30qo1lt44h.jpg',
// 'https://wx3.sinaimg.cn/mw690/006GBbhsgy1hrr8ft3n1xj30qo1lttfj.jpg',
// 'https://img0.baidu.com/it/u=478268086,1615431340&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1422',
// 'http://img1.baidu.com/it/u=2765617566,1784779795&fm=253&app=138&f=JPEG?w=800&h=1422',
// 'http://img1.baidu.com/it/u=3976997469,1117915877&fm=253&app=138&f=JPEG?w=800&h=1422',
// 'http://img2.baidu.com/it/u=2046358127,1974219077&fm=253&app=138&f=JPEG?w=800&h=1067',
// 'https://ww3.sinaimg.cn/mw690/006yaq9Sly1hs43bvng4aj30zu25o14e.jpg',
// 'https://t12.baidu.com/it/u=2931212906,232777334&fm=30&app=106&f=JPEG?w=640&h=801&s=9890BEFB44A2F6ED5E044E7C0300C056',
// 'https://wx1.sinaimg.cn/mw690/006GBbhsgy1hroov8a3ajj30sg0sgte9.jpg',
// 'https://wx1.sinaimg.cn/mw690/006GBbhsgy1hroovyci8cj30sg0sgdlf.jpg',
// 'https://inews.gtimg.com/om_bt/O18oTw5vDODDirm97CxSxEDNENnnBczswypwl1FPLa6vAAA/641',
// 'https://wx2.sinaimg.cn/mw690/008rHio4gy1hrfydwnfjoj30fo0mljw3.jpg',
// 'https://ww4.sinaimg.cn/mw690/008rHio4gy1hrfye03z82j30fo0mm0xa.jpg',
// 'https://q1.itc.cn/images01/20240521/9d817a5297e542dcbdcf2de18f375fba.jpeg',
// 'https://ww4.sinaimg.cn/mw690/008rHio4gy1hrfydxmfwmj30d70j3juj.jpg',
// 'https://inews.gtimg.com/news_bt/OWFYrnMu4_rgFxIGgvQG3zXURwb5HJY0bgUXUVYZAmy4IAA/641',
// 'https://ww1.sinaimg.cn/mw690/008rHio4gy1hrfydx5rbzj30fo0mn43b.jpg',
// 'https://ww1.sinaimg.cn/mw690/006yaq9Sly1hqsdy4w3wlj30zu25onpd.jpg',
// 'https://img1.baidu.com/it/u=185449433,1606816365&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=593',
// 'https://n.sinaimg.cn/sinacn20100/600/w1080h1920/20200201/6ea2-intiarp7651233.jpg',
// 'https://mvideopic.bdstatic.com/mvideo/6afefa07c4c3aaff8e6154a5def8159f.jpg?for=bg',
// 'https://n.sinaimg.cn/sinacn10119/492/w1080h1812/20190928/850d-ifffqup6975192.jpg',
// 'https://n.sinaimg.cn/sinacn15/755/w640h915/20180517/79d5-harvfhu6474881.jpg'
]


export class PageRouter {
  routerName: string
  title: string

  constructor(title: string, routerName: string) {
    this.routerName = routerName
    this.title = title
  }
}

export let pageData: Array<PageRouter> =
  [new PageRouter('图片缓存工具', 'pages/ImageCachePage'),
    new PageRouter('跳转三方工具', 'pages/JumpOtherAppPage'),
    new PageRouter('弹窗分装调研', 'pages/DialogPage'),
    new PageRouter('约束布局测量', 'pages/LayoutMeasurePage')]

export class CatchImage {
  static imageCatchPielMap: image.PixelMap | undefined | string
}