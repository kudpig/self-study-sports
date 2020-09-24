//= require jquery
//= require popper
//= require rails-ujs
//= require bootstrap-material-design/dist/js/bootstrap-material-design.js

function previewFileWithId(selector) {
  // 操作する要素を引数'selector'として受け取っており'image_tag'が入っているイメージ
  // この関数のゴールは、image_tagが持つHTML属性である"src"を差し替えること。

  const target = this.event.target;
  // event.targetでイベント発生源である要素を取得できる。
  const file = target.files[0];
  // event.targetにはfilesというプロパティが設定されていて、"File"というオブジェクトが配列のように管理されている。
  // 複数投稿を考慮し、files全てを取得
  const reader  = new FileReader();
  // ファイルを読み込むためのFileReaderオブジェクトを定義

  if (file) {


    reader.readAsDataURL(file);
    // Fileオブジェクトが取得できた場合。
    // readAsDataURL()はFileReaderの読取メソッドで、FileオブシェクトのURLを読み込む。
  } else {
    selector.src = "";
  }

  reader.onloadend = function () {
    // onloardendはFileReaderのイベント。データの読み込みが終了した時に発火し、設定した関数が呼び出され実行される。
      selector.src = reader.result;
      // FileReaderのresultプロパティ。読み取り操作が完了した後でのみ有効となり、データの形式は読取メソッドの種類により異なる。
      // 読み込んだファイルの結果を"selector.src"に当てている。
  }
}