/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-10-10 21:30</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	import flash.system.Capabilities;
	
	public class VersionControll 
	{
	
		private static var _os:String;
		private static var _version:Array;
		
		
		private static var i:int, i_max:int;
		{
			_os = Capabilities.version.split(" ")[0];
			_version = Capabilities.version.split(" ")[1].split(",");
			for (i = 0, i_max = _version.length; i < i_max; i++) 
			{
				_version[i] = parseInt(_version[i]);
			}
		}
		
		public static function checkVersion(major:int, minor:int = -1, revision:int = -1):Boolean
		{
			var pass:Boolean = _version[0] >= major;
			if (minor >= 0) {
				pass &&=  _version[1] >= minor;
				if (revision >= 0) {
					pass &&=  _version[2] >= revision;
					
				}
			}
			return pass;
		}
		
		static public function get os():String 
		{
			return _os;
		}
		static public function get major():int 
		{
			return _version[0];
		}
		static public function get minor():int 
		{
			return _version[1];
		}
		static public function get revision():int 
		{
			return _version[2];
		}
	}

}