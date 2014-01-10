package pl.asria.tools.managers.ui 
{
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class Notyfications 
	{
		private static var _systemInterpreter:NotyficationsInterpreter;
		public function Notyfications() 
		{
			
		}
		
		public static function set interpreter(value:NotyficationsInterpreter):void
		{
			_systemInterpreter = value;
		}
		
		public static function make(type:String):void
		{
			if (_systemInterpreter)
				_systemInterpreter.interprete(type);
			else
			{
				trace("System Notyfications not initialized")
			}
		}
	}

}