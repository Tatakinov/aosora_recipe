# Aosora recipe

SHIORI「Aosora」で使える便利かもしれないユーティリティ群です。

## 導入方法

aosora\_recipe.zipをダウンロードして展開したものを
ghost/master/以下に配置して、
ghost.asprojに

```
aosora_recipe/array_utils.as
aosora_recipe/map_utils.as
aosora_recipe/object_utils.as
```

を追記すれば使えるようになります。

## 使い方

### array\_utils

配列に適用出来る関数群です。

- Range(a, b)

`a`以上`b`未満の数字を要素に持つ配列を生成します。

```
local array = Range(3, 5); // => [3, 4]
```

- Shuffle(a)

配列`a`の内容をシャッフルした配列を返します。

```
local array = Shuffle([1, 2, 3, 4, 5]); // => [3, 1, 4, 2, 5]
```

- IndexOf(a, b)

配列の中で最初に`b`が現れた位置を返します。
`b`が関数の場合は、配列の要素を引数に関数'b'を実行した結果が`true`になった位置を返します。

```
local pos = IndexOf([3, 1, 4, 1, 5, 9], 1); // => 1
local pos = IndexOf([3, 1, 4, 1, 5, 9], function(v) { return v > 3; }); // => 2
```

- Reverse(a)

配列`a`の要素を逆順にしたものを返します。

```
local array = Reverse([1, 2, 3, 4, 5]); // => [5, 4, 3, 2, 1]
```

- Take(a, n)

配列`a`の最初から`n`要素のみからなる配列を返します。

```
local array = Take([1, 2, 3, 4, 5], 3); // => [1, 2, 3]
```

- Drop(a, n)

配列`a`の最初の`n`要素を除いた配列を返します。

```
local array = Drop([1, 2, 3, 4, 5], 2); // [3, 4, 5]
```

- Slice(a, begin, end)

配列`a`の`begin`要素目から、`end`の手前までを要素に持つ配列を返します。

```
local array = Slice([1, 2, 3, 4, 5], 1, 4); // => [2, 3, 4]
```

- SumBy(a, f[, args])

配列`a`の各要素に関数`f`を適用した結果を足した結果を返します。
`args`は関数`f`の追加引数です。

```
local result = SumBy([1, 2, 3], function(v) { return 2 * v; }); // => 12
local result = SumBy([1, 2, 3], function(v, arg) { return v + arg; }, 1); // => 9
```

- Sum(a)

配列`a`の各要素を足した結果を返します。

```
local result = Sum([1, 2, 3]); // => 6
```

- Join(a, delim)

配列`a`の各要素を、デリミタを`delim`として連結します。
要素はすべてToString()されます。

```
local result = Join([1, 2, 3], ","); => "1,2,3"
```

- DistinctBy(a, f)

ソート済みの配列`a`の要素に関数`f`適用した結果でユニーク処理をした結果を返します。

```
local array = DistinctBy([{n: 1, s: "a"}, {n: 1, s: "b"}, {n: 2, s: "c"}], function(v) { return v.n; }); // => [{n: 1, s: "a"}, {n: 2, s: "c"}]
```

- Distinct(a)

ソート済みの配列`a`の要素でユニーク処理をした結果を返します。

```
local array = Distinct([1, 1, 2, 3, 3, 4, 4, 4, 5]); => [1, 2, 3, 4, 5]
```

- SortBy(a, f)

比較関数`f`で配列`a`をソートした結果を返します。
ソートは安定ソートです。

```
local array = SortBy([1, 3, 2, 5, 4], function(a, b) { return a > b; }); // => [5, 4, 3, 2, 1]
```

- Sort(a)

配列`a`を昇順ソートした結果を返します。
ソートは安定ソートです。

```
local array = Sort([1, 3, 2, 5, 4], function(a, b) { return a > b; }); // => [1, 2, 3, 4, 5]
```

- MaxBy(a, f)

配列`a`の要素に関数`f`を適用した結果が一番大きい要素を返します。

```
local result = MaxBy([{n: 1, s: "a"}, {n: 2, s: "b"}], function(v) { return v.n; }); // => {n: 2, s: "b"}
```

- Max(a)

配列`a`の中で一番大きな要素を返します。

```
local result = Max([1, 3, 2, 5, 4]); // => 5
```

- MinBy(a, f)

配列`a`の要素に関数`f`を適用した結果が一番小さい要素を返します。

```
local result = MinBy([{n: 1, s: "a"}, {n: 2, s: "b"}], function(v) { return v.n; }); // => {n: 1, s: "a"}
```

- Min(a)

配列`a`の中で一番小さな要素を返します。

```
local result = Min([1, 3, 2, 5, 4]); // => 1
```

### map\_utils

連想配列に適用出来る関数群です。

- Values(m)

連想配列`m`の要素のvalueを配列にして返します。
要素の順番はKeysに依存します。

```
local array = Values({a: 1, b: 3, c: 2}); // => [1, 3, 2]
```

### object\_utils

文字列/配列/連想配列に適用出来る関数群です。

- Clone(obj)

オブジェクト`obj`のディープコピーを行います。
シャローコピーでは問題がある場合に使います。
シャローコピーで発生する問題は以下。

```
local a = [1, 2, 3];
local b = a;
b[0] = 5; // a => [5, 2, 3] !
```

Cloneを使うことで回避できる。

```
local a = [1, 2, 3];
local b = Clone(a);
b[0] = 5; // a => [1, 2, 3]
```

- Map(obj, f[, args])

オブジェクト`obj`の各要素に関数`f`を適用した結果を代入します。
`args`は関数`f`の追加引数です。

```
local array = Map([1, 2, 3], function(i, v) { return 2 * v; }); // => [2, 4, 6]
local array = Map({a: 1, b: 2}, function(k, v, arg) { return 2 * v + arg; }, 1); // => {a: 3, b: 5}
```

- Filter(obj, f[, args])

オブジェクト`obj`の各要素に関数`f`を適用した結果が`true`になる要素からなるオブジェクトを返します。
`args`は関数`f`の追加引数です。

```
local array = Filter([1, 2, 3], function(i, v) { return v % 2 == 0; }); // => [2]
local array = Filter({t1: "a", t2: "b", u: "c"}, function(k, v, arg) { return k.StartsWith(arg); }, "t"); // => [2, 3]
```

- Any(obj, f[, args])

オブジェクト`obj`の各要素に`f`を適用した結果が`true`になる要素が存在すれば`true`、そうでなければ`false`を返します。
`args`は関数`f`の追加引数です。

```
local result = Any("12345", function(i, v) { return v.ToNumber() % 3 == 0; }); // => true
```

- Contain(obj, args)

オブジェクト`obj`の要素に`args`が含まれていたら`true`、そうでなければ`false`を返します。
`args`は関数`f`の追加引数です。

```
local result = Contain([1, 2, 3, 4, 5], 3); // => true
local result = Contain("this is test", "."); // => false
```

- All(obj, f[, args])

オブジェクト`obj`の各要素に関数`f`を適用した結果がすべて`true`であれば`true`、そうでなければ`false`を返します。
`args`は関数`f`の追加引数です。

```
local result = All([1, 2, 3, 4, 5], function(i, v) { return v % 2 == 0; }); // => false
local result = All([2, 2, 4, 4, 4], function(i, v) { return v % 2 == 0; }); // => true
```
