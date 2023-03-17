var BozulacakUrunler = new Array();
var girenCikan = new Array();
var isVp = 0;

var Obj = {
  in_Stock: {
    pid: 0,
    sid: 0,
    isVp: 0,
    quantity: 0,
  },
  boom_stocks: [
    {
      pid: 0,
      sid: 0,
      quantity: 0,
    },
  ],
  operationType: 0, //0 Tandem,1 Yön Değiştir,
  girenCikanlar: girenCikan,
};
