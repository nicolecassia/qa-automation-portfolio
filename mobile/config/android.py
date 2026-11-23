"""Configuração Android - usar com: robot -V mobile/config/android.py mobile/tests"""
import os

_APPS_DIR = os.path.join(os.path.dirname(__file__), "..", "apps")
_APP = os.getenv("ANDROID_APP", os.path.abspath(os.path.join(_APPS_DIR, "MyDemoAppRN.apk")))

PLATFORM = "android"

CAPS = {
    "platformName": "Android",
    "appium:automationName": "UiAutomator2",
    "appium:deviceName": os.getenv("ANDROID_DEVICE", "Android Emulator"),
    "appium:app": _APP,
    "appium:appWaitActivity": "com.saucelabs.mydemoapp.rn.MainActivity",
    "appium:autoGrantPermissions": True,
    "appium:newCommandTimeout": 240,
    "appium:uiautomator2ServerInstallTimeout": 120000,
    "appium:adbExecTimeout": 120000,
}

# Localizadores que mudam de uma plataforma para outra
LOC_OPEN_MENU = "accessibility_id=open menu"
LOC_OPEN_CART = "accessibility_id=cart badge"
