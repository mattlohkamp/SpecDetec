package ml.SpecDetec	{
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.events.ProgressEvent;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.desktop.NativeProcess;

	public class SpecDetec	{

			//	internals

		private static var _ready:Boolean = false;
		public static function get ready():Boolean	{	return _ready;	}
		
		private static var _inProgress:Boolean = false;
		private static var _callback:Function = null;
		
			//	data

				//	CPU
		
		private static var _cpuName:String = undefined;
		public static function get cpuName():String	{	return _cpuName;	}
		public static function isCPUIntel():Boolean	{	return _cpuName.indexOf('Intel') != -1;	}
		public static function isCPUAMD():Boolean	{	return _cpuName.indexOf('AMD') != -1;	}
		
			//	methods
		
		public static function init(callback:Function = null):void	{
			if(!_inProgress){
				_inProgress = true;
				_ready = false;
				
				_callback = (callback != null) ? callback : null;
				
				if((Capabilities.os.indexOf("Windows") >= 0))	{
					initWindows();
				}
			}
		}

			//	WINDOWS STUFF
		
		private static const cmdFile:File = File.applicationDirectory.resolvePath('WindowsDesktop.cmd');
		private static var winRaw:String;
		private static var winProcess:NativeProcess;
		
		private static function initWindows():void	{

			winRaw = new String();
			winProcess = new NativeProcess();
			var nativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = cmdFile; 
			
			/*
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, stdoutError);
				process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, ioErrorHandlder);
				process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, ioErrorHandlder);
			*/
			
			winProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, function(e:ProgressEvent):void	{
				winRaw += winProcess.standardOutput.readUTFBytes(winProcess.standardOutput.bytesAvailable);
			});
			winProcess.addEventListener(NativeProcessExitEvent.EXIT, function(e:NativeProcessExitEvent):void	{
				parseWindows();
			});
			winProcess.start(nativeProcessStartupInfo);
		}
		private static function parseWindows():void	{
			var resultJSON:Object = JSON.parse(winRaw.replace(/\s*\R/g, '\n').replace(/^\s*|[\t ]+$/gm, '').replace(/[\u000d\u000a\u0008]+/g,'').replace( /\\/g, ''));
			_cpuName = resultJSON.cpu.split('=')[1];
			onComplete();
		}
		
		private static function onComplete():void	{
			_inProgress = false;
			_ready = true;
			if(_callback != null)	_callback();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/*		
			Event list:		
				Event.COMPLETE		Fires when system specs have been collected and are ready to be accessed -
									SpecDetec.ready should be true at that point, and values that can not be found will be undefined rather than null.
		*/
		
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            dispatcher.removeEventListener(type, listener, useCapture);
        }
        public static function dispatchEvent(event:Event):Boolean {
            return dispatcher.dispatchEvent(event);
        }
        public static function hasEventListener(type:String):Boolean {
            return dispatcher.hasEventListener(type);
        }
	}
}