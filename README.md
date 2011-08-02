# CADemo
*Core Animationのサンプル集です。*
Core Animation以外のサンプルも含まれるかもしれません。

## くるくる回転
CAKeyframeAnimationにより90度の回転を連続して一周させることでViewを回転させます。
どこかでCABasicAnimationで720度回転させる例を見た気がするけど気にしない（見つけたら修正します）。

## めくれる
CATransitionのTypeに"pageCurl"を指定して途中までのページめくりを行います。
パラメータの指定によっては途中で止める事も可能です。
問題はPageCurlがアンドキュメントという事です。

## 点滅
CAKeyframeAnimationによりopacity値を変更させることで点滅させます。
対象がViewではなくLayerなため、alphaではなくopacityなことがポイント。

## スクロール
UIScrollViewを利用した選択画面サンプルです。
選択のタップ操作には対応していません。
