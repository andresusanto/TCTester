# Test Case Tester
![TC Tester](/../screenshoot/screenshoots/tctester.jpg?raw=true "TC Tester")

Program yang dapat melakukan Blackbox Testing untuk program lain dengan menggunakan komparasi file input dan output.

## Kegunaan
Program ini dapat melakukan pengecekan secara *Black Box* dengan memanfatkan file masukan input (\*.in) yang di-masukan ke `stdin` program, lalu mengecek output yang dihasilkan oleh program dan membandingkannya dengan file output (\*.out) dengan menggunakan `fc`.
Program ini sangat bermanfaat untuk melakukan banyak pengetesan dengan banyak test case (memudahkan anda untuk tidak mengetik banyak command di command line).

## Program Terkompilasi
Program yang sudah di-*compile* tersedia dalam arsip `build.rar`.

## Step penggunaan
1. Compile EXE
2. Masukan semua file .in dan .out satu folder dengan exe yang sudah di-compile
3. Klik browse
4. Jika ada yang gagal, anda bisa lihat perbedaannya di file .in.compare hasil eksekusi. 

**NOTE:** Program ini menghasilkan .in.cek (hasil pengecekan) dan .in.compare

## License
MIT License
