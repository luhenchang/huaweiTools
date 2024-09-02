class LayoutModifier {
  width: number
  height: number
  fontSize?: number
  id: string
  alignRules: AlignRuleOption
  margin?: Padding
  backColor: Color

  constructor(width: number, height: number, backColor: Color, fonSize: number, id: string, alignRules: AlignRuleOption,
    margin?: Padding) {
    this.width = width
    this.height = height
    this.fontSize = fonSize
    this.id = id
    this.alignRules = alignRules
    this.margin = margin
    this.backColor = backColor
  }
}

@Entry
@Component
struct LayoutMeasurePage {
  @State message: string = 'Hello World';
  @State layoutModifierModel: LayoutModifier[] = []

  aboutToAppear(): void {
    let model1: LayoutModifier = new LayoutModifier(0, 100, Color.Orange, 33, 'titleTvId', {
      top: { anchor: '__container__', align: VerticalAlign.Top },
      left: { anchor: '__container__', align: HorizontalAlign.Start }
    }, { left: 30, right: 30 })
    this.layoutModifierModel.push(model1)

    let model12: LayoutModifier = new LayoutModifier(0, 100, Color.Green, 16, 'titleSubTvId', {
      top: { anchor: 'titleTvId', align: VerticalAlign.Bottom },
      left: { anchor: 'titleTvId', align: HorizontalAlign.Start },
      right: { anchor: 'titleTvId', align: HorizontalAlign.End },
    }, { left: 30, right: 30, top: 10 })
    this.layoutModifierModel.push(model12)

  }

  build() {
    RelativeContainer() {
      ForEach(this.layoutModifierModel, (data: LayoutModifier, index) => {
        Text(this.message)
          .id(data.id)
          .fontSize(data.fontSize)
          .constraintSize({ maxWidth: '100%' })
          .width(data.width > 0 ? data.width : '100%')
          .height(data.height > 0 ? data.height : '100%')
          .margin(data.margin)
          .backgroundColor(Color.Orange)
          .fontWeight(FontWeight.Bold)
          .alignRules(data.alignRules)
      })

    }
    .height('100%')
    .width('100%')
  }
}