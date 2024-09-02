export class LayoutModel {
  scheme?: Scheme[]
}

export class Scheme {
  uid?: string
  layer?: number
  marginTop?: MarginTop
  marginLeft?: MarginLeft
  marginRight?: MarginRight
  marginBottom?: MarginBottom
  superView?: string
  bgColor?: string
  controlType?: string
}

export class MarginBottom {
  size?: string
  reference?: string
  layout?: string
}

export class MarginRight {
  size?: string
  reference?: string
  layout?: string
}

export class MarginLeft {
  size?: string
  reference?: string
  layout?: string
}

export class MarginTop {
  size?: string
  reference?: string
  layout?: string
}
