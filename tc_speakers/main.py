#!/usr/bin/env python3
import tinytuya as tt
import argparse


d_KRK_R = tt.OutletDevice(
    dev_id="bf2b01655dfe3fb32fupge",
    address="192.168.0.195",
    local_key="(T+gxxMiOKAv3Lru",
    version=3.3,
)

d_KRK_L = tt.OutletDevice(
    dev_id="bf1b6602d2742bf93d8izy",
    address="192.168.0.35",
    local_key="V)>ArRhvT$1:etdC",
    version=3.3,
)

parser = argparse.ArgumentParser(description="Tuya Smart Controller for speakers (WIP)")
parser.add_argument("-1", "--on", help="Turn on speakers", action="store_true")
parser.add_argument("-0", "--off", help="Turn off speakers", action="store_true")
parser.add_argument("--verbose", help="Output Device status", action="store_true")
args = parser.parse_args()


if args.verbose:
    data_KRK_R = d_KRK_R.status()
    data_KRK_L = d_KRK_L.status()
    print(f"Status KRK R: {data_KRK_R}")
    print(f"Status KRK L: {data_KRK_L}")

if args.on:
    try:
        d_KRK_R.turn_on()
        d_KRK_L.turn_on()
    except Exception as e:
        raise e
elif args.off:
    try:
        d_KRK_R.turn_off()
        d_KRK_L.turn_off()
    except Exception as e:
        raise e
