# GCC and LLVM compiler test for SpacemiT V100-C2201 (case 1-15).
# Prepare Ruyi toolchain packages and CoreMark sources as documented.
# Virtual environments are created during recording.
# SSH alias V100-1 must support non-interactive authentication via its jump host.
# Ruyi: 0.54.0; gnu-ruyisdk: 0.20260625.0; llvm-ruyisdk: 22.1.8-ruyi.20260625.
# Every compile uses the complete ISA reported by /proc/cpuinfo.

#$ expect \$
#$ delay 0
ssh -tt -o BatchMode=yes -o LogLevel=ERROR V100-1 'env HISTFILE=/dev/null PS1="V100-1 $ " bash --noprofile --norc -i'
#$ expect V100-1 \$ $
cd ~/v100-case-1-15-20261117 && export PATH="$PWD/bin:$PATH"
#$ expect V100-1 \$ $
set -e -o pipefail
#$ expect V100-1 \$ $
clear
#$ expect V100-1 \$ $
#$ delay 15
ruyi version
#$ expect Ruyi 0\.54\.0
#$ expect V100-1 \$ $
printf '\033[1;34mCase 1-15 | SpacemiT V100-C2201 | Full CPU ISA\033[0m\n'
#$ expect V100-1 \$ $
cat /sys/class/dmi/id/sys_vendor /sys/class/dmi/id/product_name; uname -smr
#$ expect V100-1 \$ $
#$ snapshot device-model
cat /proc/cpuinfo | grep -i isa
#$ expect V100-1 \$ $
#$ snapshot device-cpuinfo
#$ wait 1200
clear
#$ expect V100-1 \$ $
#$ wait 150
printf '\033[1;34m[1/4] RuyiSDK GCC | Hello World | Full CPU ISA\033[0m\n'
#$ expect V100-1 \$ $
ruyi venv -t 'gnu-ruyisdk(0.20260625.0)' manual gcc-env
#$ expect V100-1 \$ $
. gcc-env/bin/ruyi-activate
#$ expect V100-1 \$ $
riscv64-ruyisdk-linux-gnu-gcc --version | head -n 1
#$ expect V100-1 \$ $
cat > hello.c <<'EOF'
#include <stdio.h>

int main(void) {
    puts("Hello, World!");
    return 0;
}
EOF
#$ expect V100-1 \$ $
riscv64-ruyisdk-linux-gnu-gcc -march=rv64imafdcvh_zicbom_zicbop_zicboz_ziccrse_zicntr_zicond_zicsr_zifencei_zihintntl_zihintpause_zihpm_zimop_zaamo_zalrsc_zawrs_zfa_zfbfmin_zfh_zfhmin_zca_zcb_zcd_zcmop_zba_zbb_zbc_zbs_zkt_zvbb_zvbc_zve32f_zve32x_zve64d_zve64f_zve64x_zvfbfmin_zvfbfwma_zvfh_zvfhmin_zvkb_zvkg_zvkned_zvknhb_zvksed_zvksh_zvkt_smaia_smstateen_ssaia_sscofpmf_ssnpm_sstc_svade_svinval_svnapot_svpbmt -mabi=lp64d -O2 hello.c -o hello-gcc
#$ expect V100-1 \$ $
./hello-gcc
#$ expect Hello, World!
#$ expect V100-1 \$ $
#$ snapshot gcc-hello
#$ wait 1200
clear
#$ expect V100-1 \$ $
#$ wait 150
printf '\033[1;34m[2/4] RuyiSDK GCC | CoreMark | Full CPU ISA | 1 thread\033[0m\n'
#$ expect V100-1 \$ $
cd coremark
#$ expect V100-1 \$ $
make CC=riscv64-ruyisdk-linux-gnu-gcc XCFLAGS="-march=rv64imafdcvh_zicbom_zicbop_zicboz_ziccrse_zicntr_zicond_zicsr_zifencei_zihintntl_zihintpause_zihpm_zimop_zaamo_zalrsc_zawrs_zfa_zfbfmin_zfh_zfhmin_zca_zcb_zcd_zcmop_zba_zbb_zbc_zbs_zkt_zvbb_zvbc_zve32f_zve32x_zve64d_zve64f_zve64x_zvfbfmin_zvfbfwma_zvfh_zvfhmin_zvkb_zvkg_zvkned_zvknhb_zvksed_zvksh_zvkt_smaia_smstateen_ssaia_sscofpmf_ssnpm_sstc_svade_svinval_svnapot_svpbmt -mabi=lp64d -O2" compile
#$ expect V100-1 \$ $
mv coremark.exe coremark-gcc
#$ expect V100-1 \$ $
./coremark-gcc
#$ expect Correct operation validated\.
#$ expect CoreMark 1\.0
#$ expect V100-1 \$ $
#$ snapshot gcc-coremark
#$ wait 1500
cd .. && ruyi-deactivate
#$ expect V100-1 \$ $
#$ wait 150
clear
#$ expect V100-1 \$ $
printf '\033[1;34m[3/4] RuyiSDK LLVM | Hello World | Full CPU ISA\033[0m\n'
#$ expect V100-1 \$ $
ruyi venv -t 'llvm-ruyisdk(22.1.8-ruyi.20260625)' manual --sysroot-from 'gnu-ruyisdk(0.20260625.0)' llvm-env
#$ expect V100-1 \$ $
. llvm-env/bin/ruyi-activate
#$ expect V100-1 \$ $
clang --version | head -n 2
#$ expect V100-1 \$ $
clang -march=rv64imafdcvh_zicbom_zicbop_zicboz_ziccrse_zicntr_zicond_zicsr_zifencei_zihintntl_zihintpause_zihpm_zimop_zaamo_zalrsc_zawrs_zfa_zfbfmin_zfh_zfhmin_zca_zcb_zcd_zcmop_zba_zbb_zbc_zbs_zkt_zvbb_zvbc_zve32f_zve32x_zve64d_zve64f_zve64x_zvfbfmin_zvfbfwma_zvfh_zvfhmin_zvkb_zvkg_zvkned_zvknhb_zvksed_zvksh_zvkt_smaia_smstateen_ssaia_sscofpmf_ssnpm_sstc_svade_svinval_svnapot_svpbmt -mabi=lp64d -O2 hello.c -o hello-llvm
#$ expect V100-1 \$ $
./hello-llvm
#$ expect Hello, World!
#$ expect V100-1 \$ $
#$ snapshot llvm-hello
#$ wait 1200
clear
#$ expect V100-1 \$ $
#$ wait 150
printf '\033[1;34m[4/4] RuyiSDK LLVM | CoreMark | Full CPU ISA | 1 thread\033[0m\n'
#$ expect V100-1 \$ $
cd coremark && make clean
#$ expect V100-1 \$ $
make CC=clang XCFLAGS="-march=rv64imafdcvh_zicbom_zicbop_zicboz_ziccrse_zicntr_zicond_zicsr_zifencei_zihintntl_zihintpause_zihpm_zimop_zaamo_zalrsc_zawrs_zfa_zfbfmin_zfh_zfhmin_zca_zcb_zcd_zcmop_zba_zbb_zbc_zbs_zkt_zvbb_zvbc_zve32f_zve32x_zve64d_zve64f_zve64x_zvfbfmin_zvfbfwma_zvfh_zvfhmin_zvkb_zvkg_zvkned_zvknhb_zvksed_zvksh_zvkt_smaia_smstateen_ssaia_sscofpmf_ssnpm_sstc_svade_svinval_svnapot_svpbmt -mabi=lp64d -O2" compile
#$ expect V100-1 \$ $
mv coremark.exe coremark-llvm
#$ expect V100-1 \$ $
./coremark-llvm
#$ expect Correct operation validated\.
#$ expect CoreMark 1\.0
#$ expect V100-1 \$ $
#$ snapshot llvm-coremark
#$ wait 1500
cd .. && ruyi-deactivate
#$ expect V100-1 \$ $
#$ wait 150
#$ wait 2000
exit
#$ expect \$
