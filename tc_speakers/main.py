#!/usr/bin/env python3
import tinytuya as tt
import argparse


d_speakers = [
    tt.OutletDevice(
        dev_id="bf2b01655dfe3fb32fupge",
        address="192.168.0.195",
        local_key="(T+gxxMiOKAv3Lru",
        version=3.3,
    ),
    tt.OutletDevice(
        dev_id="bf1b6602d2742bf93d8izy",
        address="192.168.0.35",
        local_key="V)>ArRhvT$1:etdC",
        version=3.3,
    ),
]

parser = argparse.ArgumentParser(description="Tuya Smart Controller for speakers (WIP)")
parser.add_argument("-1", "--on", help="Turn on speakers", action="store_true")
parser.add_argument("-0", "--off", help="Turn off speakers", action="store_true")
parser.add_argument("--verbose", help="Output Device status", action="store_true")
args = parser.parse_args()


def print_status() -> None:
    """Print the status of all devices"""
    for i, device in enumerate(d_speakers, start=1):
        status = device.status()
        print(f"Status KRK {chr(64+i)}: {status}")


def set_state(state):
    """Set the state of all devices (1 for on, 0 for off)."""
    try:
        for device in d_speakers:
            if state == 1:
                device.turn_on()
            elif state == 0:
                device.turn_off()
    except Exception as e:
        print(f"Error while changing device state: {e}")


if __name__ == "__main__":
    if args.on:
        set_state(1)
    elif args.off:
        set_state(0)

    if args.verbose:
        print_status()
