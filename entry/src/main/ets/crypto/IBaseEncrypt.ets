

export interface IBaseEncrypt {
  encode(original: Uint8Array): Promise<Uint8Array>;
  decode(encrypt: Uint8Array): Promise<Uint8Array>;

}