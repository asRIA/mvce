package pl.asria.tools
{
	import flash.display.Stage;
	import pl.asria.tools.utils.trace.etrace;
	
	/**
	 * ...
	 * @author Piotr Paczkowski
	 */
	public class Tool 
	{
		static private var _stage:Stage;
		protected static var _debugMode:Boolean;
		
		CONFIG::debug {_debugMode = true;}
		
		public function Tool() 
		{
		}
		
		public static function init(stage:Stage):void
		{
			_stage = stage;
		}
		
		static public function get stage():Stage 
		{
			if(!_stage) etrace("No stage registred")
			return _stage;
		}
		
		public static function get debugMode():Boolean 
		{
			return _debugMode;
		}
	}
	
}