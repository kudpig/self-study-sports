window.addEventListener('DOMContentLoaded',function() {
  var mySwiper = new Swiper('.swiper-container', {
    pagination: {
      el: '.swiper-pagination',
    },
  })
});
// 全てのDOMが構成されてからイベントを発火させる記述とした。
// 以下記述は公式の通り。
