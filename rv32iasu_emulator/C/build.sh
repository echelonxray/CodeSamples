#!/bin/bash

cd $(dirname ${BASH_SOURCE[0]})

EXPORT=""
EXPORT="$EXPORT -Wl,--export=InitEmu"
EXPORT="$EXPORT -Wl,--export=RunEmu"
EXPORT="$EXPORT -Wl,--export=get_uart0_rxfifo_circbuf_loc"
EXPORT="$EXPORT -Wl,--export=get_uart0_rxfifo_circbuf_len"
EXPORT="$EXPORT -Wl,--export=get_uart0_rxfifo_circbuf_index_loc"
EXPORT="$EXPORT -Wl,--export=get_uart0_rxfifo_circbuf_quecount_loc"
EXPORT="$EXPORT -Wl,--export=get_firmware_loc"
EXPORT="$EXPORT -Wl,--export=get_disk_image_loc"
EXPORT="$EXPORT -Wl,--export=get_cmp_time_hi_loc"
EXPORT="$EXPORT -Wl,--export=get_cmp_time_lo_loc"
EXPORT="$EXPORT -Wl,--export=get_start_time_hi_loc"
EXPORT="$EXPORT -Wl,--export=get_start_time_lo_loc"
EXPORT="$EXPORT -Wl,--export=get_lock_loc"
EXPORT="$EXPORT -Wl,--export=get_running_state_loc"

clang \
	-D WASM_BUILD \
	-matomics \
	-mbulk-memory \
	-O3 \
	-flto \
	--target=wasm32 \
	-nostdlib \
	-std=c99 \
	$EXPORT \
	-Wl,--lto-O3 \
	-Wl,--no-entry \
	-Wl,--strip-all \
	-Wl,--import-memory \
	-Wl,--shared-memory \
	-Wl,--max-memory=268435456 \
	-Wl,--initial-memory=268435456 \
	-Wl,--allow-undefined \
	-Wl,-z,stack-size=$[16 * 1024 * 1024] \
	echelon_xray_emu.c -o echelon_xray_emu.wasm

gcc -lpthread -march=native -O3 ./echelon_xray_emu.c -o ./echelon_xray_emu.out
strip ./echelon_xray_emu.out

exit 0
