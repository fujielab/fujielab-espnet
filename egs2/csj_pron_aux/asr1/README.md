# CSJ alternative recipe

## 概要
- 発音形のテキスト
- フィラー（F），言い淀み（D）と通常トークンを組み合わせた特殊トークンを導入
- 文節区切りに | を追加

## データ整形

- `db.sh`の中の`CSJ`の項目を編集
```
CSJDATATOP=/autofs/diamond/share/corpus/CSJ
CSJVER=usb
```

- `local/data.sh`を実行

- 学習時は，stage 3（`dump`の作成）から開始

