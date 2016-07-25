#! /bin/sh

for N; do
        f=`bc <<-end_bc
                        n = $N
                        scale = 0
                        a_indx = 0
                        while (n % 2 == 0) {
                                2
                                n /= 2
                        }
                        r = sqrt(n)
                        for (i = 3; i <= r; i += 2) {
                                while (n % i == 0) {
                                        i
                                        n = n / i;
                                }
                        }
                        if (n > 2) {
                                if (n == $N) {
                                        n; 1
                                } else {
                                        n
                                }
                        }
                end_bc
        `
        echo $N : $f
done
