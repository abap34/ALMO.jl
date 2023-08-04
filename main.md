# \ すごい / Python入門 \すごい/

Pythonでは、input関数を使って、print関数を使うことで入出力が行えます。
入力を受け取って末尾に"！"をつけて出力するプログラムを作ってみましょう。

:::code
title=Hello ALMO
sample_in=in/helloalmo/sample.txt
sample_out=out/helloalmo/sample.txt
in=in/helloalmo/*.txt
out=out/helloalmo/*.txt
:::


続いて、
入力として整数が空白区切りで与えるので、
総和を出力してみましょう。

Pythonでは、sum関数を使うことで総和を計算できます！

$$
\sum_{i=1}^{n} a_i
$$

それでは実際にやってみましょう！

:::code
title=Sum Function
sample_in=in/sumfunc/sample.txt
sample_out=out/sumfunc/sample.txt
in=in/sumfunc/*.txt
out=out/sumfunc/*.txt
:::

<br>




ところで....


文字列

$$
S
$$

と、
文字列の組

$$
T_0 = (T_{0,1}, T_{0,2}), T_1 = (T_{1,1}, T_{1,2}), \cdots,
T_{n-1} = (T_{n-1,1}, T_{n-1,2}), T_n = (T_{n,1}, T_{n,2})
$$

が与えられます。

そして、次のような操作をしてよいです。

Sの連続部分文字列
$$
S_{i,j} 
$$

について、

$$
\exists k \in \{0, 1, \cdots, n\} \quad T_{k,1} = S_{i,j}
$$

ならばSのi文字目からj文字目までを

$$
T_{k,2}
$$

に置き換える。

この操作は何回行っても良いです。

この操作を行った操作によって得ることができる文字列のうち長さが最小のものの長さを求めてください。



入力の形式...

$$
\begin{align}
&S \\
&N \\
&T_{0,1} \quad T_{0,2} \\
&T_{1,1} \quad T_{1,2} \\
&\vdots \\
&T_{N-1,1} \quad T_{N-1,2} \\
&T_{N,1} \quad T_{N,2} \\
\end{align}
$$



:::code
title=String Replace
sample_in=in/strreplace/sample.txt
sample_out=out/strreplace/sample.txt
in=in/strreplace/*.txt
out=out/strreplace/*.txt
:::

