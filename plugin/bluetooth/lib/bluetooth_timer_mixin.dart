import 'bluetooth_timeout.dart';
import 'package:bluetooth/pigeon_generate/bluetooth_api.g.dart';

mixin BluetoothTimerMixin {
   void cancelAllTimer() {
     BluetoothTimeout.timers.forEach((key, value) {value.cancel();});
     BluetoothTimeout.timers.clear();
   }

   void addConnectTimeout(void Function() callback,{int duration = 30}) {
     BluetoothTimeout.setTimeout(callback, key: ApiBluetoothDeviceStateType.connected.toString(), duration: duration);
   }

   void cancelConnectTimeout() {
     BluetoothTimeout.cancel(key: ApiBluetoothDeviceStateType.connected.toString());
   }

   void addScanIntervalTimeOut(void Function() callback,{int duration = 2}){
     BluetoothTimeout.setTimeout(callback,
         key: ApiBluetoothDeviceConnectErrorType.timeOut.toString(), duration: duration);
   }

   void cancelScanIntervalTimeOut() {
     BluetoothTimeout.cancel(key: ApiBluetoothDeviceConnectErrorType.timeOut.toString());
   }
}