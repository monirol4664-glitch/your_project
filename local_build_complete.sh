#!/bin/bash

echo "=== Mathematica Console APK Builder ==="

# Install dependencies
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk android-sdk build-essential git zip unzip curl wget python3-pip

# Setup Android SDK
export ANDROID_HOME=$HOME/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/30.0.3

# Download Android SDK if not exists
if [ ! -d "$ANDROID_HOME" ]; then
    echo "Downloading Android SDK..."
    mkdir -p $ANDROID_HOME
    cd $HOME
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
    unzip -q commandlinetools-linux-11076708_latest.zip
    mkdir -p $ANDROID_HOME/cmdline-tools
    mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest
    
    # Accept licenses
    yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
    
    # Install build tools
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"
fi

# Install Python packages
echo "Installing Python packages..."
pip3 install --user buildozer cython kivy sympy

# Create project
mkdir -p mathematica_project/src/mathematica_console
cd mathematica_project

# Create app files
cat > src/mathematica_console/main.py << 'EOF'
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.textinput import TextInput
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.scrollview import ScrollView
import sympy as sp

class MathApp(App):
    def build(self):
        layout = BoxLayout(orientation='vertical', padding=10)
        
        self.output = ScrollView()
        self.output_layout = BoxLayout(orientation='vertical', size_hint_y=None)
        self.output_layout.bind(minimum_height=self.output_layout.setter('height'))
        self.output.add_widget(self.output_layout)
        
        input_layout = BoxLayout(size_hint_y=0.15)
        self.input = TextInput(hint_text='Enter expression...', multiline=False)
        btn = Button(text='=', size_hint_x=0.2)
        btn.bind(on_press=self.calculate)
        
        input_layout.add_widget(self.input)
        input_layout.add_widget(btn)
        
        layout.add_widget(self.output)
        layout.add_widget(input_layout)
        
        self.add_output("Mathematica Console Ready!")
        return layout
    
    def add_output(self, text):
        label = Label(text=text, size_hint_y=None, height=40, halign='left')
        label.bind(size=label.setter('text_size'))
        self.output_layout.add_widget(label)
    
    def calculate(self, instance):
        try:
            result = sp.sympify(self.input.text)
            self.add_output(f"In: {self.input.text}")
            self.add_output(f"Out: {result}")
            self.input.text = ""
        except Exception as e:
            self.add_output(f"Error: {e}")

if __name__ == '__main__':
    MathApp().run()
EOF

# Create buildozer.spec
cat > buildozer.spec << 'EOF'
[app]
title = Math Console
package.name = mathconsole
package.domain = org.mathconsole
version = 1.0.0
source.dir = src/mathematica_console
requirements = python3,kivy,sympy
android.api = 30
android.minapi = 21
android.ndk = 23b
android.sdk = 30
log_level = 2

[buildozer]
android.accept_sdk_license = True
EOF

# Build
echo "Building APK..."
buildozer android debug

echo "Build complete! Check bin/ directory for APK"
