package  {
	
	import flash.display.MovieClip;
	import ml.SpecDetec.*;
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class WindowsDesktop extends MovieClip {
		
		public function WindowsDesktop() {
			SpecDetec.init(renderSpecs);
		}
		private function renderSpecs():void	{
			trace(SpecDetec.cpuName);
		}
	}
	
}
