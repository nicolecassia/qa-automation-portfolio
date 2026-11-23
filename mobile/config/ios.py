"""Configuração iOS - usar com: robot -V mobile/config/ios.py mobile/tests

Precisa de macOS com Xcode. Se IOS_UDID não for informado, usa o primeiro
simulador de iPhone disponível na máquina.
"""
import glob
import json
import os
import subprocess

_APPS_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "apps"))


def _find_app():
    if os.getenv("IOS_APP"):
        return os.getenv("IOS_APP")
    apps = glob.glob(os.path.join(_APPS_DIR, "**", "*.app"), recursive=True)
    return apps[0] if apps else os.path.join(_APPS_DIR, "MyRNDemoApp.app")


def _find_simulator():
    """Devolve (udid, nome, versão) do primeiro iPhone disponível."""
    if os.getenv("IOS_UDID"):
        return os.getenv("IOS_UDID"), os.getenv("IOS_DEVICE", "iPhone"), os.getenv("IOS_VERSION")
    try:
        output = subprocess.run(
            ["xcrun", "simctl", "list", "devices", "available", "-j"],
            capture_output=True, text=True, check=True,
        ).stdout
    except (OSError, subprocess.CalledProcessError):
        return None, os.getenv("IOS_DEVICE", "iPhone 16"), os.getenv("IOS_VERSION")
    for runtime, devices in sorted(json.loads(output)["devices"].items(), reverse=True):
        if ".iOS-" not in runtime:
            continue
        version = runtime.split(".iOS-")[-1].replace("-", ".")
        for device in devices:
            if device["name"].startswith("iPhone"):
                return device["udid"], device["name"], version
    return None, os.getenv("IOS_DEVICE", "iPhone 16"), os.getenv("IOS_VERSION")


_UDID, _DEVICE, _VERSION = _find_simulator()

PLATFORM = "ios"

CAPS = {
    "platformName": "iOS",
    "appium:automationName": "XCUITest",
    "appium:deviceName": _DEVICE,
    "appium:app": _find_app(),
    "appium:newCommandTimeout": 240,
    "appium:wdaLaunchTimeout": 300000,
    "appium:wdaConnectionTimeout": 300000,
    "appium:simulatorStartupTimeout": 300000,
}
if _UDID:
    CAPS["appium:udid"] = _UDID
if _VERSION:
    CAPS["appium:platformVersion"] = _VERSION

# Localizadores que mudam de uma plataforma para outra
LOC_OPEN_MENU = "accessibility_id=tab bar option menu"
LOC_OPEN_CART = "accessibility_id=tab bar option cart"
