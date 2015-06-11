package ml.SpecDetec	{
	import flash.system.Capabilities;

	public class SpecDetec	{
		private static var mode:String = null;
		private static var _ready:Boolean = false;
		public static function get ready():Boolean	{	return _ready;	}
		public static function init(callback:Function = null):void	{
			
			if(callback){
				
			}
			
			if((Capabilities.os.indexOf("Windows") >= 0))	{
				mode = AIROSConstants.WINDOWS;
			}
			
			switch(mode){
				case AIROSConstants.WINDOWS:
					initWindows();
				break;
				default:
					//	error
				break;
			}
		}
		private function initWindows():void	{
			
		}
	}
}