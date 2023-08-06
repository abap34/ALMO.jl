# すごい Python入門 


## 入出力

Pythonは、input関数を使って入力を受け取ることができ、
print関数を使うことで出力が行えます。

まずは、入力を受け取って末尾に"！"をつけて出力するプログラムを作ってみましょう。


:::code
title=Hello ALMO
sample_in=in/helloalmo/sample.txt
sample_out=out/helloalmo/sample.txt
in=in/helloalmo/*.txt
out=out/helloalmo/*.txt
:::


## for文

Pythonでは、for文を使って繰り返し処理を行うことができます。

入力としてnを受け取り、for文を使って、1からnまでの数字を出力するプログラムを作ってみましょう。


:::code
title=For loop
sample_in=in/forloop/sample.txt
sample_out=out/forloop/sample.txt
in=in/forloop/*.txt
out=out/forloop/*.txt
:::


## ビット全探索

Pythonでは、ビット全探索を行うことができます。

入力としてnを受け取り、0から2^n-1までの数字を2進数で出力するプログラムを作ってみましょう。

$$
0 \leq n \leq 20
$$

が保証されているとします。

:::code
title=Bit search
sample_in=in/bitsearch/sample.txt
sample_out=out/bitsearch/sample.txt
in=in/bitsearch/*.txt
out=out/bitsearch/*.txt
:::


## sin関数

sin関数をテイラー展開によって計算しましょう。

sin(x)のテイラー展開は以下のようになります。

$$
\begin{align}
\sin x &= \sum_{n=0}^{\infty} \frac{(-1)^n}{(2n+1)!}x^{2n+1} \\
&= x - \frac{x^3}{3!} + \frac{x^5}{5!} - \frac{x^7}{7!} + \cdots
\end{align}
$$

入力としてxを受け取り、sin(x)を出力するプログラムを作ってみましょう。

$$
-10 \leq x \leq 10
$$

が保証されているとします。 誤差は1e-3であれば許容されます。

:::code
title=Sin function
sample_in=in/sinfunction/sample.txt
sample_out=out/sinfunction/sample.txt
in=in/sinfunction/*.txt
out=out/sinfunction/*.txt
judge=err_1e-3
:::

