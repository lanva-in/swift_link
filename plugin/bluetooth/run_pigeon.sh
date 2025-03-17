#!/bin/bash

path_dart='lib/pigeon_generate'
path_ios='ios/Classes/pigeon_generate'
path_android='android/src/main/kotlin/com/desktop/bluetooth/pigeon_generate'
path_macos='macos/Classes/pigeon_generate'

mkdir -p $path_dart
mkdir -p $path_ios
mkdir -p $path_android
mkdir -p $path_macos

# 描述 api文件名 dart文件名称 ios文件名  macos文件名
module_list=(
   '桌面蓝牙Api api_bluetooth bluetooth_api.g BluetoothApi.g BluetoothApi.g BluetoothMacApi.g'
);

for i in "${module_list[@]}"; do
    sub_list=($i)
    desc=${sub_list[0]}
    api_file=${sub_list[1]}
    dart_file=${sub_list[2]}
    ios_file=${sub_list[3]}
    android_file=${sub_list[4]}
    macos_file=${sub_list[5]}

    echo "执行 ${desc} ..."

    flutter pub run pigeon \
             --input pigeons/$api_file.dart \
             --dart_out $path_dart/$dart_file.dart \
             --swift_out $path_ios/$ios_file.swift \
             --kotlin_out $path_android/$android_file.kt \
             --kotlin_package "com.desktop.bluetooth.pigeon_generate.${api_file}"\
             --swift_out $path_macos/$macos_file.swift

    echo "执行 ${desc} 完成"
    echo ''
done



exit 0
